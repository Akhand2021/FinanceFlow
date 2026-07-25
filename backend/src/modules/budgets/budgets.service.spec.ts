import { Test, TestingModule } from '@nestjs/testing';
import { BudgetsService } from './budgets.service';
import { BudgetsRepository } from './budgets.repository';
import { BudgetEntity } from './entities/budget.entity';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { NotFoundException, ConflictException } from '@common/exceptions/api.exception';

describe('BudgetsService', () => {
  let service: BudgetsService;
  let repository: BudgetsRepository;

  const mockBudget = new BudgetEntity({
    id: 'budget-123',
    userId: 'user-123',
    name: 'July 2026 Monthly Budget',
    amount: 5000,
    month: new Date('2026-07-01'),
    isActive: true,
    alertThreshold: 80,
    items: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BudgetsService,
        {
          provide: BudgetsRepository,
          useValue: {
            findAllByUserId: jest.fn(),
            findById: jest.fn(),
            findByMonth: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<BudgetsService>(BudgetsService);
    repository = module.get<BudgetsRepository>(BudgetsRepository);
  });

  it('should return all user budgets', async () => {
    jest.spyOn(repository, 'findAllByUserId').mockResolvedValue([mockBudget]);
    const result = await service.getUserBudgets('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('July 2026 Monthly Budget');
  });

  it('should return current budget for month', async () => {
    jest.spyOn(repository, 'findByMonth').mockResolvedValue(mockBudget);
    const result = await service.getCurrentBudget('user-123');
    expect(result).toBeDefined();
    expect(result?.id).toBe('budget-123');
  });

  it('should throw ConflictException if budget for month already exists', async () => {
    const dto: CreateBudgetDto = {
      name: 'July Budget',
      amount: 5000,
      month: '2026-07-01T00:00:00.000Z',
    };
    jest.spyOn(repository, 'findByMonth').mockResolvedValue(mockBudget);

    await expect(service.createBudget('user-123', dto)).rejects.toThrow(
      ConflictException,
    );
  });

  it('should create new budget if none exists for month', async () => {
    const dto: CreateBudgetDto = {
      name: 'August Budget',
      amount: 6000,
      month: '2026-08-01T00:00:00.000Z',
    };
    jest.spyOn(repository, 'findByMonth').mockResolvedValue(null);
    jest.spyOn(repository, 'create').mockResolvedValue(mockBudget);

    const result = await service.createBudget('user-123', dto);
    expect(result).toBeDefined();
    expect(repository.create).toHaveBeenCalledWith('user-123', dto);
  });

  it('should throw NotFoundException if budget ID does not exist', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.getBudgetById('invalid-budget', 'user-123'),
    ).rejects.toThrow(NotFoundException);
  });
});
