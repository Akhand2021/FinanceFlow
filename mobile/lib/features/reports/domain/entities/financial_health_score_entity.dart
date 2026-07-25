import 'package:equatable/equatable.dart';

class ScoreBreakdownEntity extends Equatable {
  final int savingsRateScore;
  final int budgetDisciplineScore;
  final int loanRatioScore;
  final int emergencyFundScore;
  final int cashFlowScore;

  const ScoreBreakdownEntity({
    required this.savingsRateScore,
    required this.budgetDisciplineScore,
    required this.loanRatioScore,
    required this.emergencyFundScore,
    required this.cashFlowScore,
  });

  @override
  List<Object?> get props => [
        savingsRateScore,
        budgetDisciplineScore,
        loanRatioScore,
        emergencyFundScore,
        cashFlowScore,
      ];
}

class FinancialMetricsEntity extends Equatable {
  final double monthlyIncome;
  final double monthlyExpense;
  final double savingsRate;
  final double totalAssets;
  final double totalLiabilities;
  final double netWorth;
  final double emergencyFundMonths;

  const FinancialMetricsEntity({
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.savingsRate,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.netWorth,
    required this.emergencyFundMonths,
  });

  @override
  List<Object?> get props => [
        monthlyIncome,
        monthlyExpense,
        savingsRate,
        totalAssets,
        totalLiabilities,
        netWorth,
        emergencyFundMonths,
      ];
}

class FinancialHealthScoreEntity extends Equatable {
  final int score; // 0 to 100
  final String rating; // POOR, FAIR, GOOD, EXCELLENT
  final ScoreBreakdownEntity breakdown;
  final FinancialMetricsEntity metrics;
  final List<String> recommendations;

  const FinancialHealthScoreEntity({
    required this.score,
    required this.rating,
    required this.breakdown,
    required this.metrics,
    required this.recommendations,
  });

  @override
  List<Object?> get props => [
        score,
        rating,
        breakdown,
        metrics,
        recommendations,
      ];
}
