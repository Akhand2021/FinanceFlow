import 'package:equatable/equatable.dart';

class BudgetItemEntity extends Equatable {
  final String id;
  final String budgetId;
  final String categoryId;
  final double limitAmount;
  final double spent;
  final dynamic category;

  const BudgetItemEntity({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.limitAmount,
    required this.spent,
    this.category,
  });

  @override
  List<Object?> get props => [id, budgetId, categoryId, limitAmount, spent, category];
}

class BudgetEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final double amount;
  final DateTime month;
  final bool isActive;
  final int alertThreshold;
  final List<BudgetItemEntity> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.month,
    required this.isActive,
    required this.alertThreshold,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        amount,
        month,
        isActive,
        alertThreshold,
        items,
        createdAt,
        updatedAt,
      ];
}
