import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { MerchantRuleEntity } from './entities/merchant-rule.entity';
import { CreateMerchantRuleDto } from './dto/create-merchant-rule.dto';

@Injectable()
export class MerchantRulesRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllByUserId(userId: string): Promise<MerchantRuleEntity[]> {
    const rules = await this.prisma.merchantRule.findMany({
      where: { userId },
      orderBy: { merchantName: 'asc' },
    });
    return rules.map((r) => this.mapToEntity(r));
  }

  async findByMerchantName(userId: string, merchantName: string): Promise<MerchantRuleEntity | null> {
    const rule = await this.prisma.merchantRule.findUnique({
      where: {
        userId_merchantName: {
          userId,
          merchantName: merchantName.trim(),
        },
      },
    });
    return rule ? this.mapToEntity(rule) : null;
  }

  async upsertRule(userId: string, dto: CreateMerchantRuleDto): Promise<MerchantRuleEntity> {
    const cleanMerchant = dto.merchantName.trim();
    const rule = await this.prisma.merchantRule.upsert({
      where: {
        userId_merchantName: {
          userId,
          merchantName: cleanMerchant,
        },
      },
      update: {
        categoryId: dto.categoryId,
        confidence: dto.confidence ?? 0.9,
      },
      create: {
        userId,
        merchantName: cleanMerchant,
        categoryId: dto.categoryId,
        confidence: dto.confidence ?? 0.8,
      },
    });
    return this.mapToEntity(rule);
  }

  async delete(id: string, userId: string): Promise<void> {
    await this.prisma.merchantRule.deleteMany({
      where: { id, userId },
    });
  }

  private mapToEntity(rule: any): MerchantRuleEntity {
    return new MerchantRuleEntity({
      id: rule.id,
      userId: rule.userId,
      merchantName: rule.merchantName,
      categoryId: rule.categoryId,
      confidence: Number(rule.confidence),
    });
  }
}
