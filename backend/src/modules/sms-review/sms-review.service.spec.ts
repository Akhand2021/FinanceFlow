import { Test, TestingModule } from '@nestjs/testing';
import { SmsReviewService } from './sms-review.service';
import { SmsReviewRepository } from './sms-review.repository';
import { SmsPendingEntity } from './entities/sms-pending.entity';
import { SmsReviewAction } from './dto/process-sms.dto';
import { NotFoundException } from '@common/exceptions/api.exception';

describe('SmsReviewService', () => {
  let service: SmsReviewService;
  let repository: SmsReviewRepository;

  const mockSmsPending = new SmsPendingEntity({
    id: 'sms-123',
    userId: 'user-123',
    smsContent: 'Rs 450.00 debited at Swiggy',
    extractedMerchant: 'Swiggy',
    extractedAmount: 450,
    extractedDate: new Date(),
    status: 'PENDING',
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SmsReviewService,
        {
          provide: SmsReviewRepository,
          useValue: {
            findAllPendingByUserId: jest.fn(),
            findById: jest.fn(),
            ingestSms: jest.fn(),
            processSms: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<SmsReviewService>(SmsReviewService);
    repository = module.get<SmsReviewRepository>(SmsReviewRepository);
  });

  it('should return pending SMS items for user', async () => {
    jest.spyOn(repository, 'findAllPendingByUserId').mockResolvedValue([mockSmsPending]);
    const result = await service.getPendingSms('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].extractedMerchant).toBe('Swiggy');
  });

  it('should ingest incoming SMS message', async () => {
    jest.spyOn(repository, 'ingestSms').mockResolvedValue(mockSmsPending);
    const result = await service.ingestSms('user-123', {
      smsContent: 'Rs 450.00 debited at Swiggy',
      extractedMerchant: 'Swiggy',
      extractedAmount: 450,
    });
    expect(result).toBeDefined();
    expect(repository.ingestSms).toHaveBeenCalled();
  });

  it('should throw NotFoundException if SMS ID is invalid', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.processSms('invalid-sms', 'user-123', { action: SmsReviewAction.ACCEPT }),
    ).rejects.toThrow(NotFoundException);
  });

  it('should process pending SMS when accepted', async () => {
    const acceptedEntity = new SmsPendingEntity({ ...mockSmsPending, status: 'ACCEPTED' });
    jest.spyOn(repository, 'findById').mockResolvedValue(mockSmsPending);
    jest.spyOn(repository, 'processSms').mockResolvedValue(acceptedEntity);

    const result = await service.processSms('sms-123', 'user-123', {
      action: SmsReviewAction.ACCEPT,
    });
    expect(result.status).toBe('ACCEPTED');
    expect(repository.processSms).toHaveBeenCalled();
  });
});
