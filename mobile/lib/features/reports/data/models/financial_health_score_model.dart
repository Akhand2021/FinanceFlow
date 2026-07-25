import '../../domain/entities/financial_health_score_entity.dart';

class ScoreBreakdownModel extends ScoreBreakdownEntity {
  const ScoreBreakdownModel({
    required super.savingsRateScore,
    required super.budgetDisciplineScore,
    required super.loanRatioScore,
    required super.emergencyFundScore,
    required super.cashFlowScore,
  });

  factory ScoreBreakdownModel.fromJson(Map<String, dynamic> json) {
    return ScoreBreakdownModel(
      savingsRateScore: json['savingsRateScore'] ?? 0,
      budgetDisciplineScore: json['budgetDisciplineScore'] ?? 0,
      loanRatioScore: json['loanRatioScore'] ?? 0,
      emergencyFundScore: json['emergencyFundScore'] ?? 0,
      cashFlowScore: json['cashFlowScore'] ?? 0,
    );
  }
}

class FinancialMetricsModel extends FinancialMetricsEntity {
  const FinancialMetricsModel({
    required super.monthlyIncome,
    required super.monthlyExpense,
    required super.savingsRate,
    required super.totalAssets,
    required super.totalLiabilities,
    required super.netWorth,
    required super.emergencyFundMonths,
  });

  factory FinancialMetricsModel.fromJson(Map<String, dynamic> json) {
    return FinancialMetricsModel(
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      monthlyExpense: (json['monthlyExpense'] as num?)?.toDouble() ?? 0.0,
      savingsRate: (json['savingsRate'] as num?)?.toDouble() ?? 0.0,
      totalAssets: (json['totalAssets'] as num?)?.toDouble() ?? 0.0,
      totalLiabilities: (json['totalLiabilities'] as num?)?.toDouble() ?? 0.0,
      netWorth: (json['netWorth'] as num?)?.toDouble() ?? 0.0,
      emergencyFundMonths: (json['emergencyFundMonths'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class FinancialHealthScoreModel extends FinancialHealthScoreEntity {
  const FinancialHealthScoreModel({
    required super.score,
    required super.rating,
    required super.breakdown,
    required super.metrics,
    required super.recommendations,
  });

  factory FinancialHealthScoreModel.fromJson(Map<String, dynamic> json) {
    return FinancialHealthScoreModel(
      score: json['score'] ?? 0,
      rating: json['rating'] ?? 'POOR',
      breakdown: ScoreBreakdownModel.fromJson(json['breakdown'] ?? {}),
      metrics: FinancialMetricsModel.fromJson(json['metrics'] ?? {}),
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
    );
  }
}
