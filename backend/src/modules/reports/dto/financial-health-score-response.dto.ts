import { ApiProperty } from '@nestjs/swagger';

export class ScoreBreakdownDto {
  @ApiProperty({ example: 18 })
  savingsRateScore!: number;

  @ApiProperty({ example: 20 })
  budgetDisciplineScore!: number;

  @ApiProperty({ example: 15 })
  loanRatioScore!: number;

  @ApiProperty({ example: 10 })
  emergencyFundScore!: number;

  @ApiProperty({ example: 20 })
  cashFlowScore!: number;
}

export class FinancialMetricsDto {
  @ApiProperty({ example: 85000.0 })
  monthlyIncome!: number;

  @ApiProperty({ example: 42530.0 })
  monthlyExpense!: number;

  @ApiProperty({ example: 49.96 })
  savingsRate!: number;

  @ApiProperty({ example: 450000.0 })
  totalAssets!: number;

  @ApiProperty({ example: 320000.0 })
  totalLiabilities!: number;

  @ApiProperty({ example: 130000.0 })
  netWorth!: number;

  @ApiProperty({ example: 3.2 })
  emergencyFundMonths!: number;
}

export class FinancialHealthScoreResponseDto {
  @ApiProperty({ example: 83 })
  score!: number;

  @ApiProperty({ example: 'GOOD' })
  rating!: string;

  @ApiProperty({ type: ScoreBreakdownDto })
  breakdown!: ScoreBreakdownDto;

  @ApiProperty({ type: FinancialMetricsDto })
  metrics!: FinancialMetricsDto;

  @ApiProperty({
    example: [
      'Increase your emergency fund to cover at least 6 months of expenses',
    ],
    type: [String],
  })
  recommendations!: string[];
}
