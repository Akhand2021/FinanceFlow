import { Test, TestingModule } from '@nestjs/testing';
import { MerchantRulesService } from './merchant-rules.service';
import { MerchantRulesRepository } from './merchant-rules.repository';
import { MerchantRuleEntity } from './entities/merchant-rule.entity';

describe('MerchantRulesService', () => {
  let service: MerchantRulesService;
  let repository: MerchantRulesRepository;

  const mockRule = new MerchantRuleEntity({
    id: 'rule-123',
    userId: 'user-123',
    merchantName: 'Swiggy',
    categoryId: 'cat-food',
    confidence: 0.9,
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MerchantRulesService,
        {
          provide: MerchantRulesRepository,
          useValue: {
            findAllByUserId: jest.fn(),
            findByMerchantName: jest.fn(),
            upsertRule: jest.fn(),
            delete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<MerchantRulesService>(MerchantRulesService);
    repository = module.get<MerchantRulesRepository>(MerchantRulesRepository);
  });

  it('should return user rules', async () => {
    jest.spyOn(repository, 'findAllByUserId').mockResolvedValue([mockRule]);
    const result = await service.getUserRules('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].merchantName).toBe('Swiggy');
  });

  it('should upsert merchant rule', async () => {
    jest.spyOn(repository, 'upsertRule').mockResolvedValue(mockRule);
    const result = await service.upsertRule('user-123', {
      merchantName: 'Swiggy',
      categoryId: 'cat-food',
    });
    expect(result).toBeDefined();
    expect(repository.upsertRule).toHaveBeenCalled();
  });
});
