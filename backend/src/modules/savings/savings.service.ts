import { Injectable } from '@nestjs/common';
import { SavingsRepository } from './savings.repository';
import { CreateGoalDto } from './dto/create-goal.dto';
import { UpdateGoalDto } from './dto/update-goal.dto';
import { AddContributionDto } from './dto/add-contribution.dto';
import { SavingGoalEntity } from './entities/saving-goal.entity';
import { NotFoundException } from '@common/exceptions/api.exception';

@Injectable()
export class SavingsService {
  constructor(private readonly savingsRepository: SavingsRepository) {}

  async getUserGoals(userId: string): Promise<SavingGoalEntity[]> {
    return this.savingsRepository.findAllByUserId(userId);
  }

  async getGoalById(id: string, userId: string): Promise<SavingGoalEntity> {
    const goal = await this.savingsRepository.findById(id, userId);
    if (!goal) {
      throw new NotFoundException('Savings Goal');
    }
    return goal;
  }

  async createGoal(userId: string, dto: CreateGoalDto): Promise<SavingGoalEntity> {
    return this.savingsRepository.create(userId, dto);
  }

  async updateGoal(
    id: string,
    userId: string,
    dto: UpdateGoalDto,
  ): Promise<SavingGoalEntity> {
    await this.getGoalById(id, userId);
    return this.savingsRepository.update(id, userId, dto);
  }

  async addContribution(
    id: string,
    userId: string,
    dto: AddContributionDto,
  ): Promise<SavingGoalEntity> {
    await this.getGoalById(id, userId);
    return this.savingsRepository.addContribution(id, dto);
  }

  async deleteGoal(id: string, userId: string): Promise<void> {
    await this.getGoalById(id, userId);
    await this.savingsRepository.softDelete(id, userId);
  }
}
