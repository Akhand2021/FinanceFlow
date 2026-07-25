import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { BudgetEntity, BudgetItemEntity } from './entities/budget.entity';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';

@Injectable()
export class BudgetsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllByUserId(userId: string): Promise<BudgetEntity[]> {
    const budgets = await this.prisma.budget.findMany({
      where: { userId, deletedAt: null },
      include: {
        items: {
          include: { category: true },
        },
      },
      orderBy: { month: 'desc' },
    });

    return Promise.all(budgets.map((b) => this.mapToEntityWithSpent(userId, b)));
  }

  async findById(id: string, userId: string): Promise<BudgetEntity | null> {
    const budget = await this.prisma.budget.findFirst({
      where: { id, userId, deletedAt: null },
      include: {
        items: {
          include: { category: true },
        },
      },
    });

    return budget ? this.mapToEntityWithSpent(userId, budget) : null;
  }

  async findByMonth(userId: string, monthDate: Date): Promise<BudgetEntity | null> {
    const startOfMonth = new Date(monthDate.getFullYear(), monthDate.getMonth(), 1);
    const endOfMonth = new Date(monthDate.getFullYear(), monthDate.getMonth() + 1, 0, 23, 59, 59);

    const budget = await this.prisma.budget.findFirst({
      where: {
        userId,
        deletedAt: null,
        month: {
          gte: startOfMonth,
          lte: endOfMonth,
        },
      },
      include: {
        items: {
          include: { category: true },
        },
      },
    });

    return budget ? this.mapToEntityWithSpent(userId, budget) : null;
  }

  async create(userId: string, dto: CreateBudgetDto): Promise<BudgetEntity> {
    const monthDate = new Date(dto.month);

    const budget = await this.prisma.budget.create({
      data: {
        userId,
        name: dto.name,
        amount: dto.amount,
        month: monthDate,
        alertThreshold: dto.alertThreshold ?? 80,
        items: {
          create: dto.items?.map((item) => ({
            categoryId: item.categoryId,
            limitAmount: item.limitAmount,
          })),
        },
      },
      include: {
        items: {
          include: { category: true },
        },
      },
    });

    return this.mapToEntityWithSpent(userId, budget);
  }

  async update(
    id: string,
    userId: string,
    dto: UpdateBudgetDto,
  ): Promise<BudgetEntity> {
    if (dto.items) {
      await this.prisma.budgetItem.deleteMany({
        where: { budgetId: id },
      });
    }

    const budget = await this.prisma.budget.update({
      where: { id },
      data: {
        name: dto.name,
        amount: dto.amount,
        month: dto.month ? new Date(dto.month) : undefined,
        alertThreshold: dto.alertThreshold,
        updatedAt: new Date(),
        items: dto.items
          ? {
              create: dto.items.map((item) => ({
                categoryId: item.categoryId,
                limitAmount: item.limitAmount,
              })),
            }
          : undefined,
      },
      include: {
        items: {
          include: { category: true },
        },
      },
    });

    return this.mapToEntityWithSpent(userId, budget);
  }

  async softDelete(id: string, userId: string): Promise<void> {
    await this.prisma.budget.updateMany({
      where: { id, userId },
      data: { deletedAt: new Date() },
    });
  }

  private async mapToEntityWithSpent(userId: string, budget: any): Promise<BudgetEntity> {
    const budgetMonth = new Date(budget.month);
    const startOfMonth = new Date(budgetMonth.getFullYear(), budgetMonth.getMonth(), 1);
    const endOfMonth = new Date(budgetMonth.getFullYear(), budgetMonth.getMonth() + 1, 0, 23, 59, 59);

    // Compute actual spent per category for this month from EXPENSE transactions
    const categoryExpenses = await this.prisma.transaction.groupBy({
      by: ['categoryId'],
      where: {
        userId,
        type: 'EXPENSE',
        deletedAt: null,
        date: {
          gte: startOfMonth,
          lte: endOfMonth,
        },
      },
      _sum: {
        amount: true,
      },
    });

    const expenseMap = new Map<string, number>();
    for (const exp of categoryExpenses) {
      expenseMap.set(exp.categoryId, Number(exp._sum.amount ?? 0));
    }

    const items = (budget.items || []).map((item: any) => {
      const spent = expenseMap.get(item.categoryId) ?? 0;
      return new BudgetItemEntity({
        id: item.id,
        budgetId: item.budgetId,
        categoryId: item.categoryId,
        limitAmount: Number(item.limitAmount),
        spent,
        category: item.category,
      });
    });

    return new BudgetEntity({
      id: budget.id,
      userId: budget.userId,
      name: budget.name,
      amount: Number(budget.amount),
      month: budget.month,
      isActive: budget.isActive,
      alertThreshold: budget.alertThreshold,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
      deletedAt: budget.deletedAt,
      items,
    });
  }
}
