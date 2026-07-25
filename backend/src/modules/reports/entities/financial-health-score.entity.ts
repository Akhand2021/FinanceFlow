export class FinancialHealthScoreEntity {
  score!: number; // 0 to 100
  rating!: string; // POOR, FAIR, GOOD, EXCELLENT
  breakdown!: {
    savingsRateScore: number;
    budgetDisciplineScore: number;
    loanRatioScore: number;
    emergencyFundScore: number;
    cashFlowScore: number;
  };
  metrics!: {
    monthlyIncome: number;
    monthlyExpense: number;
    savingsRate: number;
    totalAssets: number;
    totalLiabilities: number;
    netWorth: number;
    emergencyFundMonths: number;
  };
  recommendations!: string[];

  constructor(partial: Partial<FinancialHealthScoreEntity>) {
    Object.assign(this, partial);
  }
}
