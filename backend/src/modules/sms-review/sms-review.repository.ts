import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { SmsPendingEntity } from './entities/sms-pending.entity';
import { IngestSmsDto } from './dto/ingest-sms.dto';
import { ProcessSmsDto, SmsReviewAction } from './dto/process-sms.dto';

@Injectable()
export class SmsReviewRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllPendingByUserId(userId: string): Promise<SmsPendingEntity[]> {
    const records = await this.prisma.smsPending.findMany({
      where: { userId, status: 'PENDING' },
      orderBy: { createdAt: 'desc' },
    });
    return records.map((r) => this.mapToEntity(r));
  }

  async findById(id: string, userId: string): Promise<SmsPendingEntity | null> {
    const record = await this.prisma.smsPending.findFirst({
      where: { id, userId },
    });
    return record ? this.mapToEntity(record) : null;
  }

  async ingestSms(userId: string, dto: IngestSmsDto): Promise<SmsPendingEntity> {
    // Check duplicate SMS content within 24h
    const twentyFourHoursAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const existing = await this.prisma.smsPending.findFirst({
      where: {
        userId,
        smsContent: dto.smsContent,
        createdAt: { gte: twentyFourHoursAgo },
      },
    });

    if (existing) {
      return this.mapToEntity(existing);
    }

    const created = await this.prisma.smsPending.create({
      data: {
        userId,
        smsContent: dto.smsContent,
        extractedMerchant: dto.extractedMerchant,
        extractedAmount: dto.extractedAmount,
        extractedDate: dto.extractedDate ? new Date(dto.extractedDate) : new Date(),
        extractedAccount: dto.extractedAccount,
        status: 'PENDING',
      },
    });

    return this.mapToEntity(created);
  }

  async processSms(
    id: string,
    userId: string,
    dto: ProcessSmsDto,
  ): Promise<SmsPendingEntity> {
    return this.prisma.$transaction(async (tx) => {
      const pending = await tx.smsPending.findFirst({
        where: { id, userId },
      });

      if (!pending) {
        throw new Error('SMS pending record not found');
      }

      if (dto.action === SmsReviewAction.REJECT) {
        const updated = await tx.smsPending.update({
          where: { id },
          data: { status: 'REJECTED', updatedAt: new Date() },
        });
        return this.mapToEntity(updated);
      }

      if (dto.action === SmsReviewAction.IGNORE) {
        const updated = await tx.smsPending.update({
          where: { id },
          data: { status: 'IGNORED', updatedAt: new Date() },
        });
        return this.mapToEntity(updated);
      }

      // ACCEPT Action
      let targetAccountId = dto.accountId;
      if (!targetAccountId) {
        const defaultAccount = await tx.account.findFirst({
          where: { userId, isDefault: true, deletedAt: null },
        });
        targetAccountId = defaultAccount?.id || (
          await tx.account.findFirst({ where: { userId, deletedAt: null } })
        )?.id;
      }

      let targetCategoryId = dto.categoryId;
      if (!targetCategoryId) {
        const defaultCategory = await tx.category.findFirst({
          where: { userId, name: 'Shopping', deletedAt: null },
        });
        targetCategoryId = defaultCategory?.id || (
          await tx.category.findFirst({ where: { userId, deletedAt: null } })
        )?.id;
      }

      if (!targetAccountId || !targetCategoryId) {
        throw new Error('User must have at least one account and category to accept transactions');
      }

      const amount = Number(pending.extractedAmount || 0);

      // Create real Transaction
      await tx.transaction.create({
        data: {
          userId,
          accountId: targetAccountId,
          categoryId: targetCategoryId,
          type: 'EXPENSE',
          amount: amount > 0 ? amount : 1.0,
          merchant: pending.extractedMerchant || 'SMS Import',
          description: pending.smsContent,
          date: pending.extractedDate || new Date(),
          isPending: false,
        },
      });

      // Deduct account balance
      await tx.account.update({
        where: { id: targetAccountId },
        data: {
          balance: { decrement: amount > 0 ? amount : 1.0 },
          updatedAt: new Date(),
        },
      });

      // Upsert Merchant Rule for auto-learning
      if (pending.extractedMerchant) {
        await tx.merchantRule.upsert({
          where: {
            userId_merchantName: {
              userId,
              merchantName: pending.extractedMerchant.trim(),
            },
          },
          update: { categoryId: targetCategoryId, confidence: 0.95 },
          create: {
            userId,
            merchantName: pending.extractedMerchant.trim(),
            categoryId: targetCategoryId,
            confidence: 0.9,
          },
        });
      }

      const updated = await tx.smsPending.update({
        where: { id },
        data: { status: 'ACCEPTED', updatedAt: new Date() },
      });

      return this.mapToEntity(updated);
    });
  }

  private mapToEntity(pending: any): SmsPendingEntity {
    return new SmsPendingEntity({
      id: pending.id,
      userId: pending.userId,
      smsContent: pending.smsContent,
      extractedMerchant: pending.extractedMerchant,
      extractedAmount: pending.extractedAmount ? Number(pending.extractedAmount) : null,
      extractedDate: pending.extractedDate,
      extractedAccount: pending.extractedAccount,
      status: pending.status,
      createdAt: pending.createdAt,
      updatedAt: pending.updatedAt,
    });
  }
}
