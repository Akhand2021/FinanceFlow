import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { TransactionEntity } from './entities/transaction.entity';
import { CreateTransactionDto, TransactionType } from './dto/create-transaction.dto';
import { UpdateTransactionDto } from './dto/update-transaction.dto';
import { QueryTransactionDto } from './dto/query-transaction.dto';

@Injectable()
export class TransactionsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(
    userId: string,
    query: QueryTransactionDto,
  ): Promise<{ data: TransactionEntity[]; total: number; page: number; limit: number }> {
    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {
      userId,
      deletedAt: null,
    };

    if (query.type) {
      where.type = query.type;
    }
    if (query.accountId) {
      where.accountId = query.accountId;
    }
    if (query.categoryId) {
      where.categoryId = query.categoryId;
    }
    if (query.startDate || query.endDate) {
      where.date = {};
      if (query.startDate) where.date.gte = new Date(query.startDate);
      if (query.endDate) where.date.lte = new Date(query.endDate);
    }
    if (query.search) {
      where.OR = [
        { merchant: { contains: query.search, mode: 'insensitive' } },
        { description: { contains: query.search, mode: 'insensitive' } },
        { notes: { contains: query.search, mode: 'insensitive' } },
      ];
    }

    const [transactions, total] = await Promise.all([
      this.prisma.transaction.findMany({
        where,
        skip,
        take: limit,
        orderBy: { [query.sortBy || 'date']: query.sortOrder || 'desc' },
        include: {
          account: true,
          category: true,
        },
      }),
      this.prisma.transaction.count({ where }),
    ]);

    return {
      data: transactions.map((t) => this.mapToEntity(t)),
      total,
      page,
      limit,
    };
  }

  async findById(id: string, userId: string): Promise<TransactionEntity | null> {
    const transaction = await this.prisma.transaction.findFirst({
      where: { id, userId, deletedAt: null },
      include: {
        account: true,
        category: true,
      },
    });
    return transaction ? this.mapToEntity(transaction) : null;
  }

  async create(userId: string, dto: CreateTransactionDto): Promise<TransactionEntity> {
    return this.prisma.$transaction(async (tx) => {
      // 1. Create transaction record
      const created = await tx.transaction.create({
        data: {
          userId,
          accountId: dto.accountId,
          categoryId: dto.categoryId,
          type: dto.type,
          amount: dto.amount,
          description: dto.description,
          merchant: dto.merchant,
          toAccountId: dto.toAccountId,
          date: new Date(dto.date),
          isPending: dto.isPending ?? false,
          isRecurring: dto.isRecurring ?? false,
          recurringPattern: dto.recurringPattern,
          tags: dto.tags ?? [],
          notes: dto.notes,
        },
        include: {
          account: true,
          category: true,
        },
      });

      // 2. Adjust account balances atomically
      await this.applyBalanceMutation(tx, dto.type, dto.accountId, dto.toAccountId, dto.amount);

      return this.mapToEntity(created);
    });
  }

  async update(
    id: string,
    userId: string,
    dto: UpdateTransactionDto,
  ): Promise<TransactionEntity> {
    return this.prisma.$transaction(async (tx) => {
      const existing = await tx.transaction.findFirst({
        where: { id, userId, deletedAt: null },
      });
      if (!existing) {
        throw new Error('Transaction not found');
      }

      // Reverse old balance mutation
      await this.revertBalanceMutation(
        tx,
        existing.type as TransactionType,
        existing.accountId,
        existing.toAccountId,
        Number(existing.amount),
      );

      // Determine new fields
      const newType = (dto.type || existing.type) as TransactionType;
      const newAccountId = dto.accountId || existing.accountId;
      const newToAccountId = dto.toAccountId !== undefined ? dto.toAccountId : existing.toAccountId;
      const newAmount = dto.amount !== undefined ? dto.amount : Number(existing.amount);

      // Apply new balance mutation
      await this.applyBalanceMutation(tx, newType, newAccountId, newToAccountId, newAmount);

      // Update record
      const updated = await tx.transaction.update({
        where: { id },
        data: {
          ...dto,
          date: dto.date ? new Date(dto.date) : undefined,
          updatedAt: new Date(),
        },
        include: {
          account: true,
          category: true,
        },
      });

      return this.mapToEntity(updated);
    });
  }

  async softDelete(id: string, userId: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const existing = await tx.transaction.findFirst({
        where: { id, userId, deletedAt: null },
      });
      if (!existing) return;

      // Reverse balance mutation
      await this.revertBalanceMutation(
        tx,
        existing.type as TransactionType,
        existing.accountId,
        existing.toAccountId,
        Number(existing.amount),
      );

      await tx.transaction.update({
        where: { id },
        data: { deletedAt: new Date() },
      });
    });
  }

  private async applyBalanceMutation(
    tx: any,
    type: TransactionType,
    accountId: string,
    toAccountId: string | null | undefined,
    amount: number,
  ): Promise<void> {
    if (type === TransactionType.INCOME) {
      await tx.account.update({
        where: { id: accountId },
        data: { balance: { increment: amount } },
      });
    } else if (type === TransactionType.EXPENSE) {
      await tx.account.update({
        where: { id: accountId },
        data: { balance: { decrement: amount } },
      });
    } else if (type === TransactionType.TRANSFER && toAccountId) {
      await tx.account.update({
        where: { id: accountId },
        data: { balance: { decrement: amount } },
      });
      await tx.account.update({
        where: { id: toAccountId },
        data: { balance: { increment: amount } },
      });
    }
  }

  private async revertBalanceMutation(
    tx: any,
    type: TransactionType,
    accountId: string,
    toAccountId: string | null | undefined,
    amount: number,
  ): Promise<void> {
    if (type === TransactionType.INCOME) {
      await tx.account.update({
        where: { id: accountId },
        data: { balance: { decrement: amount } },
      });
    } else if (type === TransactionType.EXPENSE) {
      await tx.account.update({
        where: { id: accountId },
        data: { balance: { increment: amount } },
      });
    } else if (type === TransactionType.TRANSFER && toAccountId) {
      await tx.account.update({
        where: { id: accountId },
        data: { balance: { increment: amount } },
      });
      await tx.account.update({
        where: { id: toAccountId },
        data: { balance: { decrement: amount } },
      });
    }
  }

  private mapToEntity(transaction: any): TransactionEntity {
    return new TransactionEntity({
      id: transaction.id,
      userId: transaction.userId,
      accountId: transaction.accountId,
      categoryId: transaction.categoryId,
      type: transaction.type,
      amount: Number(transaction.amount),
      description: transaction.description,
      merchant: transaction.merchant,
      toAccountId: transaction.toAccountId,
      receiptId: transaction.receiptId,
      isPending: transaction.isPending,
      isRecurring: transaction.isRecurring,
      recurringPattern: transaction.recurringPattern,
      tags: transaction.tags ?? [],
      notes: transaction.notes,
      date: transaction.date,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
      deletedAt: transaction.deletedAt,
      account: transaction.account,
      toAccount: transaction.toAccount,
      category: transaction.category,
    });
  }
}
