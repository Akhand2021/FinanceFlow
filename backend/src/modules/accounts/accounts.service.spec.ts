import { Test, TestingModule } from '@nestjs/testing';
import { AccountsService } from './accounts.service';
import { AccountsRepository } from './accounts.repository';
import { AccountEntity } from './entities/account.entity';
import { AccountType, CreateAccountDto } from './dto/create-account.dto';
import { NotFoundException } from '@common/exceptions/api.exception';

describe('AccountsService', () => {
  let service: AccountsService;
  let repository: AccountsRepository;

  const mockAccount = new AccountEntity({
    id: 'account-123',
    userId: 'user-123',
    name: 'HDFC Bank',
    type: AccountType.BANK,
    balance: 5000,
    currency: 'USD',
    isDefault: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AccountsService,
        {
          provide: AccountsRepository,
          useValue: {
            findAllByUserId: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<AccountsService>(AccountsService);
    repository = module.get<AccountsRepository>(AccountsRepository);
  });

  it('should return all accounts for user', async () => {
    jest.spyOn(repository, 'findAllByUserId').mockResolvedValue([mockAccount]);
    const result = await service.getUserAccounts('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('HDFC Bank');
  });

  it('should return account by ID', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(mockAccount);
    const result = await service.getAccountById('account-123', 'user-123');
    expect(result.id).toBe('account-123');
  });

  it('should throw NotFoundException if account does not exist', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.getAccountById('invalid-id', 'user-123'),
    ).rejects.toThrow(NotFoundException);
  });

  it('should create new account', async () => {
    const dto: CreateAccountDto = {
      name: 'Cash In Hand',
      type: AccountType.CASH,
      balance: 1000,
    };
    jest.spyOn(repository, 'create').mockResolvedValue(mockAccount);
    const result = await service.createAccount('user-123', dto);
    expect(result).toBeDefined();
    expect(repository.create).toHaveBeenCalledWith('user-123', dto);
  });
});
