import 'package:equatable/equatable.dart';

class GoalContributionEntity extends Equatable {
  final String id;
  final String goalId;
  final double amount;
  final String? note;
  final DateTime createdAt;

  const GoalContributionEntity({
    required this.id,
    required this.goalId,
    required this.amount,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, goalId, amount, note, createdAt];
}

class SavingGoalEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final double targetAmount;
  final double currentAmount;
  final String? icon;
  final String? color;
  final DateTime? targetDate;
  final String priority;
  final bool isActive;
  final List<GoalContributionEntity> contributions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SavingGoalEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.targetAmount,
    required this.currentAmount,
    this.icon,
    this.color,
    this.targetDate,
    required this.priority,
    required this.isActive,
    required this.contributions,
    required this.createdAt,
    required this.updatedAt,
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    final pct = (currentAmount / targetAmount) * 100;
    return pct > 100 ? 100.0 : pct;
  }

  double get remainingAmount {
    final rem = targetAmount - currentAmount;
    return rem < 0 ? 0.0 : rem;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        targetAmount,
        currentAmount,
        icon,
        color,
        targetDate,
        priority,
        isActive,
        contributions,
        createdAt,
        updatedAt,
      ];
}
