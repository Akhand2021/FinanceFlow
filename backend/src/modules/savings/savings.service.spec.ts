import { Test, TestingModule } from '@nestjs/testing';
import { SavingsService } from './savings.service';
import { SavingsRepository } from './savings.repository';
import { SavingGoalEntity } from './entities/saving-goal.entity';
import { CreateGoalDto, GoalPriority } from './dto/create-goal.dto';
import { NotFoundException } from '@common/exceptions/api.exception';

describe('SavingsService', () => {
  let service: SavingsService;
  let repository: SavingsRepository;

  const mockGoal = new SavingGoalEntity({
    id: 'goal-123',
    userId: 'user-123',
    name: 'Emergency Fund',
    targetAmount: 10000,
    currentAmount: 2500,
    priority: GoalPriority.HIGH,
    isActive: true,
    contributions: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SavingsService,
        {
          provide: SavingsRepository,
          useValue: {
            findAllByUserId: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            addContribution: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<SavingsService>(SavingsService);
    repository = module.get<SavingsRepository>(SavingsRepository);
  });

  it('should return all user goals', async () => {
    jest.spyOn(repository, 'findAllByUserId').mockResolvedValue([mockGoal]);
    const result = await service.getUserGoals('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Emergency Fund');
  });

  it('should return goal by ID', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(mockGoal);
    const result = await service.getGoalById('goal-123', 'user-123');
    expect(result.id).toBe('goal-123');
  });

  it('should throw NotFoundException if goal does not exist', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.getGoalById('invalid-goal', 'user-123'),
    ).rejects.toThrow(NotFoundException);
  });

  it('should add contribution to goal', async () => {
    const updatedGoal = new SavingGoalEntity({ ...mockGoal, currentAmount: 3000 });
    jest.spyOn(repository, 'findById').mockResolvedValue(mockGoal);
    jest.spyOn(repository, 'addContribution').mockResolvedValue(updatedGoal);

    const result = await service.addContribution('goal-123', 'user-123', {
      amount: 500,
      note: 'Monthly deposit',
    });

    expect(result.currentAmount).toBe(3000);
    expect(repository.addContribution).toHaveBeenCalledWith('goal-123', {
      amount: 500,
      note: 'Monthly deposit',
    });
  });

  it('should create new savings goal', async () => {
    const dto: CreateGoalDto = {
      name: 'New Car',
      targetAmount: 25000,
      priority: GoalPriority.MEDIUM,
    };
    jest.spyOn(repository, 'create').mockResolvedValue(mockGoal);
    const result = await service.createGoal('user-123', dto);
    expect(result).toBeDefined();
    expect(repository.create).toHaveBeenCalledWith('user-123', dto);
  });
});
