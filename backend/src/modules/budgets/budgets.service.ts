import { Injectable } from '@nestjs/common';
import { BudgetsRepository } from './budgets.repository';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';
import { BudgetEntity } from './entities/budget.entity';
import { NotFoundException, ConflictException } from '@common/exceptions/api.exception';

@Injectable()
export class BudgetsService {
  constructor(private readonly budgetsRepository: BudgetsRepository) {}

  async getUserBudgets(userId: string): Promise<BudgetEntity[]> {
    return this.budgetsRepository.findAllByUserId(userId);
  }

  async getBudgetById(id: string, userId: string): Promise<BudgetEntity> {
    const budget = await this.budgetsRepository.findById(id, userId);
    if (!budget) {
      throw new NotFoundException('Budget');
    }
    return budget;
  }

  async getCurrentBudget(userId: string): Promise<BudgetEntity | null> {
    return this.budgetsRepository.findByMonth(userId, new Date());
  }

  async createBudget(userId: string, dto: CreateBudgetDto): Promise<BudgetEntity> {
    const existing = await this.budgetsRepository.findByMonth(userId, new Date(dto.month));
    if (existing) {
      throw new ConflictException('Budget for this month already exists');
    }
    return this.budgetsRepository.create(userId, dto);
  }

  async updateBudget(
    id: string,
    userId: string,
    dto: UpdateBudgetDto,
  ): Promise<BudgetEntity> {
    await this.getBudgetById(id, userId);
    return this.budgetsRepository.update(id, userId, dto);
  }

  async deleteBudget(id: string, userId: string): Promise<void> {
    await this.getBudgetById(id, userId);
    await this.budgetsRepository.softDelete(id, userId);
  }
}
