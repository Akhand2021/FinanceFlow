import { Test, TestingModule } from '@nestjs/testing';
import { LoansService } from './loans.service';
import { LoansRepository } from './loans.repository';
import { LoanEntity } from './entities/loan.entity';
import { CreateLoanDto, LoanType } from './dto/create-loan.dto';
import { NotFoundException } from '@common/exceptions/api.exception';

describe('LoansService', () => {
  let service: LoansService;
  let repository: LoansRepository;

  const mockLoan = new LoanEntity({
    id: 'loan-123',
    userId: 'user-123',
    name: 'Home Loan',
    type: LoanType.HOME_LOAN,
    lender: 'HDFC Bank',
    principal: 500000,
    currentAmount: 450000,
    interestRate: 8.5,
    emiAmount: 4500,
    startDate: new Date('2025-01-01'),
    isActive: true,
    payments: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LoansService,
        {
          provide: LoansRepository,
          useValue: {
            findAllByUserId: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            recordPayment: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<LoansService>(LoansService);
    repository = module.get<LoansRepository>(LoansRepository);
  });

  it('should return all user loans', async () => {
    jest.spyOn(repository, 'findAllByUserId').mockResolvedValue([mockLoan]);
    const result = await service.getUserLoans('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Home Loan');
  });

  it('should return loan by ID', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(mockLoan);
    const result = await service.getLoanById('loan-123', 'user-123');
    expect(result.id).toBe('loan-123');
  });

  it('should throw NotFoundException if loan does not exist', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.getLoanById('invalid-loan', 'user-123'),
    ).rejects.toThrow(NotFoundException);
  });

  it('should record loan EMI payment', async () => {
    const updatedLoan = new LoanEntity({ ...mockLoan, currentAmount: 446500 });
    jest.spyOn(repository, 'findById').mockResolvedValue(mockLoan);
    jest.spyOn(repository, 'recordPayment').mockResolvedValue(updatedLoan);

    const result = await service.recordPayment('loan-123', 'user-123', {
      accountId: 'account-123',
      amount: 4500,
      principalAmount: 3500,
      interestAmount: 1000,
      note: 'July EMI',
    });

    expect(result.currentAmount).toBe(446500);
    expect(repository.recordPayment).toHaveBeenCalled();
  });

  it('should create new loan', async () => {
    const dto: CreateLoanDto = {
      name: 'Car Loan',
      type: LoanType.CAR_LOAN,
      principal: 20000,
      interestRate: 7.5,
      startDate: '2026-01-01T00:00:00.000Z',
    };
    jest.spyOn(repository, 'create').mockResolvedValue(mockLoan);
    const result = await service.createLoan('user-123', dto);
    expect(result).toBeDefined();
    expect(repository.create).toHaveBeenCalledWith('user-123', dto);
  });
});
