import { Test, TestingModule } from '@nestjs/testing';
import { TransactionsService } from './transactions.service';
import { TransactionsRepository } from './transactions.repository';
import { TransactionEntity } from './entities/transaction.entity';
import { TransactionType, CreateTransactionDto } from './dto/create-transaction.dto';
import { NotFoundException, BadRequestException } from '@common/exceptions/api.exception';

describe('TransactionsService', () => {
  let service: TransactionsService;
  let repository: TransactionsRepository;

  const mockTransaction = new TransactionEntity({
    id: 'tx-123',
    userId: 'user-123',
    accountId: 'account-123',
    categoryId: 'category-123',
    type: TransactionType.EXPENSE,
    amount: 450,
    merchant: 'Swiggy',
    isPending: false,
    isRecurring: false,
    tags: ['food'],
    date: new Date(),
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TransactionsService,
        {
          provide: TransactionsRepository,
          useValue: {
            findAll: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<TransactionsService>(TransactionsService);
    repository = module.get<TransactionsRepository>(TransactionsRepository);
  });

  it('should return paginated transactions', async () => {
    jest.spyOn(repository, 'findAll').mockResolvedValue({
      data: [mockTransaction],
      total: 1,
      page: 1,
      limit: 20,
    });

    const result = await service.getTransactions('user-123', { page: 1, limit: 20 });
    expect(result.data).toHaveLength(1);
    expect(result.total).toBe(1);
  });

  it('should throw BadRequestException if TRANSFER has no toAccountId', async () => {
    const dto: CreateTransactionDto = {
      accountId: 'account-1',
      categoryId: 'category-1',
      type: TransactionType.TRANSFER,
      amount: 500,
      date: new Date().toISOString(),
    };

    await expect(service.createTransaction('user-123', dto)).rejects.toThrow(
      BadRequestException,
    );
  });

  it('should throw BadRequestException if TRANSFER source and destination are same', async () => {
    const dto: CreateTransactionDto = {
      accountId: 'account-1',
      toAccountId: 'account-1',
      categoryId: 'category-1',
      type: TransactionType.TRANSFER,
      amount: 500,
      date: new Date().toISOString(),
    };

    await expect(service.createTransaction('user-123', dto)).rejects.toThrow(
      BadRequestException,
    );
  });

  it('should create transaction successfully', async () => {
    const dto: CreateTransactionDto = {
      accountId: 'account-1',
      categoryId: 'category-1',
      type: TransactionType.EXPENSE,
      amount: 450,
      merchant: 'Swiggy',
      date: new Date().toISOString(),
    };

    jest.spyOn(repository, 'create').mockResolvedValue(mockTransaction);
    const result = await service.createTransaction('user-123', dto);
    expect(result.id).toBe('tx-123');
    expect(repository.create).toHaveBeenCalledWith('user-123', dto);
  });

  it('should throw NotFoundException if transaction does not exist', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.getTransactionById('invalid-tx', 'user-123'),
    ).rejects.toThrow(NotFoundException);
  });
});
