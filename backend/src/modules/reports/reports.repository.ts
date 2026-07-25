import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { FinancialHealthScoreEntity } from './entities/financial-health-score.entity';
import { ReportsSummaryResponseDto } from './dto/reports-summary-response.dto';
import { ReportsQueryDto } from './dto/reports-query.dto';

@Injectable()
export class ReportsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async getReportsSummary(
    userId: string,
    query: ReportsQueryDto,
  ): Promise<ReportsSummaryResponseDto> {
    const now = new Date();
    const startDate = query.startDate
      ? new Date(query.startDate)
      : new Date(now.getFullYear(), now.getMonth(), 1);
    const endDate = query.endDate
      ? new Date(query.endDate)
      : new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59);

    // 1. Account Balances Total
    const accounts = await this.prisma.account.findMany({
      where: { userId, deletedAt: null },
    });
    const accountsBalanceTotal = accounts.reduce(
      (acc, curr) => acc + Number(curr.balance),
      0,
    );

    // 2. Savings Goals Total
    const savingsGoals = await this.prisma.savingGoal.findMany({
      where: { userId, deletedAt: null },
    });
    const savingsTotal = savingsGoals.reduce(
      (acc, curr) => acc + Number(curr.currentAmount),
      0,
    );

    const totalAssets = accountsBalanceTotal + savingsTotal;

    // 3. Loans Principal Remaining
    const loans = await this.prisma.loan.findMany({
      where: { userId, deletedAt: null },
    });
    const totalLiabilities = loans.reduce(
      (acc, curr) => acc + Number(curr.currentAmount),
      0,
    );

    const netWorth = totalAssets - totalLiabilities;

    // 4. Income & Expense for target period
    const transactions = await this.prisma.transaction.findMany({
      where: {
        userId,
        deletedAt: null,
        date: { gte: startDate, lte: endDate },
      },
      include: { category: true },
    });

    let totalIncome = 0;
    let totalExpense = 0;
    const categoryMap = new Map<string, { name: string; color: string; amount: number }>();

    for (const t of transactions) {
      const amt = Number(t.amount);
      if (t.type === 'INCOME') {
        totalIncome += amt;
      } else if (t.type === 'EXPENSE') {
        totalExpense += amt;
        const catName = t.category?.name || 'Uncategorized';
        const color = t.category?.color || '0xFF8E8DFF';
        const currCat = categoryMap.get(catName) || { name: catName, color, amount: 0 };
        currCat.amount += amt;
        categoryMap.set(catName, currCat);
      }
    }

    const netSavings = totalIncome - totalExpense;

    const categoryBreakdown = Array.from(categoryMap.values()).map((item) => ({
      categoryName: item.name,
      color: item.color,
      amount: item.amount,
      percentage: totalExpense > 0 ? Number(((item.amount / totalExpense) * 100).toFixed(2)) : 0,
    }));

    return {
      netWorth,
      totalAssets,
      totalLiabilities,
      totalIncome,
      totalExpense,
      netSavings,
      categoryBreakdown,
    };
  }

  async calculateFinancialHealthScore(
    userId: string,
  ): Promise<FinancialHealthScoreEntity> {
    const summary = await this.getReportsSummary(userId, {});

    const monthlyIncome = summary.totalIncome > 0 ? summary.totalIncome : 1.0;
    const monthlyExpense = summary.totalExpense;
    const savingsRate = Number((((monthlyIncome - monthlyExpense) / monthlyIncome) * 100).toFixed(2));

    // 1. Savings Rate Score (Max 20)
    let savingsRateScore = 5;
    if (savingsRate >= 30) savingsRateScore = 20;
    else if (savingsRate >= 20) savingsRateScore = 15;
    else if (savingsRate >= 10) savingsRateScore = 10;

    // 2. Budget Discipline Score (Max 20)
    const currentBudget = await this.prisma.budget.findFirst({
      where: { userId, deletedAt: null },
      include: { items: true },
    });

    let budgetDisciplineScore = 15;
    if (currentBudget) {
      const budgetLimit = Number(currentBudget.amount);
      if (budgetLimit > 0) {
        const spentRatio = (monthlyExpense / budgetLimit) * 100;
        if (spentRatio <= 90) budgetDisciplineScore = 20;
        else if (spentRatio <= 100) budgetDisciplineScore = 15;
        else budgetDisciplineScore = 5;
      }
    }

    // 3. Loan Ratio Score (Max 20)
    const loans = await this.prisma.loan.findMany({
      where: { userId, deletedAt: null },
    });
    const totalEmi = loans.reduce((acc, curr) => acc + Number(curr.emiAmount || 0), 0);
    const emiRatio = (totalEmi / monthlyIncome) * 100;

    let loanRatioScore = 20;
    if (emiRatio > 50) loanRatioScore = 5;
    else if (emiRatio > 35) loanRatioScore = 10;
    else if (emiRatio > 20) loanRatioScore = 15;

    // 4. Emergency Fund Score (Max 20)
    const emergencyGoal = await this.prisma.savingGoal.findFirst({
      where: {
        userId,
        name: { contains: 'Emergency', mode: 'insensitive' },
        deletedAt: null,
      },
    });

    const emergencySaved = emergencyGoal ? Number(emergencyGoal.currentAmount) : 0;
    const targetSixMonthsExpense = monthlyExpense * 6;
    const emergencyFundMonths =
      monthlyExpense > 0 ? Number((emergencySaved / monthlyExpense).toFixed(1)) : 0;

    let emergencyFundScore = 5;
    if (targetSixMonthsExpense > 0) {
      const ratio = emergencySaved / targetSixMonthsExpense;
      if (ratio >= 1.0) emergencyFundScore = 20;
      else if (ratio >= 0.5) emergencyFundScore = 15;
      else if (ratio >= 0.1) emergencyFundScore = 10;
    }

    // 5. Cash Flow Score (Max 20)
    const cashFlowScore = monthlyIncome >= monthlyExpense ? 20 : 5;

    const totalScore =
      savingsRateScore +
      budgetDisciplineScore +
      loanRatioScore +
      emergencyFundScore +
      cashFlowScore;

    let rating = 'POOR';
    if (totalScore >= 80) rating = 'EXCELLENT';
    else if (totalScore >= 65) rating = 'GOOD';
    else if (totalScore >= 50) rating = 'FAIR';

    const recommendations: string[] = [];
    if (savingsRate < 20) {
      recommendations.push(
        'Aim to save at least 20% of your income by trimming non-essential expenses.',
      );
    }
    if (emergencyFundMonths < 6) {
      recommendations.push(
        `Build an emergency fund covering at least 6 months of living expenses (currently ~${emergencyFundMonths} months).`,
      );
    }
    if (emiRatio > 35) {
      recommendations.push(
        'Your loan EMIs exceed 35% of monthly income. Focus on paying down high-interest debt.',
      );
    }
    if (budgetDisciplineScore < 15) {
      recommendations.push(
        'Review your monthly budget limits to prevent overspending.',
      );
    }
    if (recommendations.length === 0) {
      recommendations.push(
        'Great job! Your finances are in healthy shape. Keep monitoring your goals.',
      );
    }

    return new FinancialHealthScoreEntity({
      score: totalScore,
      rating,
      breakdown: {
        savingsRateScore,
        budgetDisciplineScore,
        loanRatioScore,
        emergencyFundScore,
        cashFlowScore,
      },
      metrics: {
        monthlyIncome,
        monthlyExpense,
        savingsRate,
        totalAssets: summary.totalAssets,
        totalLiabilities: summary.totalLiabilities,
        netWorth: summary.netWorth,
        emergencyFundMonths,
      },
      recommendations,
    });
  }
}
