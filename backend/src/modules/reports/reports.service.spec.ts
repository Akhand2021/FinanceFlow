import { Test, TestingModule } from '@nestjs/testing';
import { ReportsService } from './reports.service';
import { ReportsRepository } from './reports.repository';
import { FinancialHealthScoreEntity } from './entities/financial-health-score.entity';
import { ReportsSummaryResponseDto } from './dto/reports-summary-response.dto';

describe('ReportsService', () => {
  let service: ReportsService;
  let repository: ReportsRepository;

  const mockSummary: ReportsSummaryResponseDto = {
    netWorth: 130000,
    totalAssets: 450000,
    totalLiabilities: 320000,
    totalIncome: 85000,
    totalExpense: 42530,
    netSavings: 42470,
    categoryBreakdown: [
      { categoryName: 'Food', color: '0xFFFF6B6B', amount: 12500, percentage: 29.39 },
    ],
  };

  const mockHealthScore = new FinancialHealthScoreEntity({
    score: 83,
    rating: 'GOOD',
    breakdown: {
      savingsRateScore: 20,
      budgetDisciplineScore: 18,
      loanRatioScore: 15,
      emergencyFundScore: 10,
      cashFlowScore: 20,
    },
    metrics: {
      monthlyIncome: 85000,
      monthlyExpense: 42530,
      savingsRate: 49.96,
      totalAssets: 450000,
      totalLiabilities: 320000,
      netWorth: 130000,
      emergencyFundMonths: 3.2,
    },
    recommendations: ['Build emergency fund to 6 months'],
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportsService,
        {
          provide: ReportsRepository,
          useValue: {
            getReportsSummary: jest.fn(),
            calculateFinancialHealthScore: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<ReportsService>(ReportsService);
    repository = module.get<ReportsRepository>(ReportsRepository);
  });

  it('should return reports summary', async () => {
    jest.spyOn(repository, 'getReportsSummary').mockResolvedValue(mockSummary);
    const result = await service.getReportsSummary('user-123', {});
    expect(result.netWorth).toBe(130000);
    expect(result.categoryBreakdown).toHaveLength(1);
  });

  it('should compute financial health score (0-100)', async () => {
    jest.spyOn(repository, 'calculateFinancialHealthScore').mockResolvedValue(mockHealthScore);
    const result = await service.getFinancialHealthScore('user-123');
    expect(result.score).toBe(83);
    expect(result.rating).toBe('GOOD');
    expect(result.recommendations).toHaveLength(1);
  });
});
