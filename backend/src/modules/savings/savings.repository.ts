import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { SavingGoalEntity, GoalContributionEntity } from './entities/saving-goal.entity';
import { CreateGoalDto } from './dto/create-goal.dto';
import { UpdateGoalDto } from './dto/update-goal.dto';
import { AddContributionDto } from './dto/add-contribution.dto';

@Injectable()
export class SavingsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllByUserId(userId: string): Promise<SavingGoalEntity[]> {
    const goals = await this.prisma.savingGoal.findMany({
      where: { userId, deletedAt: null },
      include: {
        contributions: {
          orderBy: { createdAt: 'desc' },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
    return goals.map((g) => this.mapToEntity(g));
  }

  async findById(id: string, userId: string): Promise<SavingGoalEntity | null> {
    const goal = await this.prisma.savingGoal.findFirst({
      where: { id, userId, deletedAt: null },
      include: {
        contributions: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });
    return goal ? this.mapToEntity(goal) : null;
  }

  async create(userId: string, dto: CreateGoalDto): Promise<SavingGoalEntity> {
    const goal = await this.prisma.savingGoal.create({
      data: {
        userId,
        name: dto.name,
        description: dto.description,
        targetAmount: dto.targetAmount,
        currentAmount: dto.currentAmount ?? 0,
        icon: dto.icon,
        color: dto.color ?? '0xFF2ECC71',
        targetDate: dto.targetDate ? new Date(dto.targetDate) : null,
        priority: dto.priority ?? 'MEDIUM',
      },
      include: { contributions: true },
    });
    return this.mapToEntity(goal);
  }

  async update(
    id: string,
    userId: string,
    dto: UpdateGoalDto,
  ): Promise<SavingGoalEntity> {
    await this.prisma.savingGoal.updateMany({
      where: { id, userId },
      data: {
        name: dto.name,
        description: dto.description,
        targetAmount: dto.targetAmount,
        currentAmount: dto.currentAmount,
        icon: dto.icon,
        color: dto.color,
        targetDate: dto.targetDate ? new Date(dto.targetDate) : undefined,
        priority: dto.priority,
        updatedAt: new Date(),
      },
    });

    const updated = await this.findById(id, userId);
    return updated!;
  }

  async addContribution(
    goalId: string,
    dto: AddContributionDto,
  ): Promise<SavingGoalEntity> {
    return this.prisma.$transaction(async (tx) => {
      // 1. Create contribution record
      await tx.goalContribution.create({
        data: {
          goalId,
          amount: dto.amount,
          note: dto.note,
        },
      });

      // 2. Increment goal currentAmount atomically
      const updatedGoal = await tx.savingGoal.update({
        where: { id: goalId },
        data: {
          currentAmount: {
            increment: dto.amount,
          },
          updatedAt: new Date(),
        },
        include: {
          contributions: {
            orderBy: { createdAt: 'desc' },
          },
        },
      });

      return this.mapToEntity(updatedGoal);
    });
  }

  async softDelete(id: string, userId: string): Promise<void> {
    await this.prisma.savingGoal.updateMany({
      where: { id, userId },
      data: { deletedAt: new Date() },
    });
  }

  private mapToEntity(goal: any): SavingGoalEntity {
    const contributions = (goal.contributions || []).map(
      (c: any) =>
        new GoalContributionEntity({
          id: c.id,
          goalId: c.goalId,
          amount: Number(c.amount),
          note: c.note,
          createdAt: c.createdAt,
        }),
    );

    return new SavingGoalEntity({
      id: goal.id,
      userId: goal.userId,
      name: goal.name,
      description: goal.description,
      targetAmount: Number(goal.targetAmount),
      currentAmount: Number(goal.currentAmount),
      icon: goal.icon,
      color: goal.color,
      targetDate: goal.targetDate,
      priority: goal.priority,
      isActive: goal.isActive,
      createdAt: goal.createdAt,
      updatedAt: goal.updatedAt,
      deletedAt: goal.deletedAt,
      contributions,
    });
  }
}
