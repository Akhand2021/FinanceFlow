import '../../domain/entities/budget_entity.dart';

class BudgetItemModel extends BudgetItemEntity {
  const BudgetItemModel({
    required super.id,
    required super.budgetId,
    required super.categoryId,
    required super.limitAmount,
    required super.spent,
    super.category,
  });

  factory BudgetItemModel.fromJson(Map<String, dynamic> json) {
    return BudgetItemModel(
      id: json['id'] ?? '',
      budgetId: json['budgetId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      limitAmount: (json['limitAmount'] as num?)?.toDouble() ?? 0.0,
      spent: (json['spent'] as num?)?.toDouble() ?? 0.0,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'budgetId': budgetId,
      'categoryId': categoryId,
      'limitAmount': limitAmount,
      'spent': spent,
      'category': category,
    };
  }
}

class BudgetModel extends BudgetEntity {
  const BudgetModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.amount,
    required super.month,
    required super.isActive,
    required super.alertThreshold,
    required super.items,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    return BudgetModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      month: json['month'] != null
          ? DateTime.parse(json['month'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      alertThreshold: json['alertThreshold'] ?? 80,
      items: rawItems.map((item) => BudgetItemModel.fromJson(item)).toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'amount': amount,
      'month': month.toIso8601String(),
      'isActive': isActive,
      'alertThreshold': alertThreshold,
      'items': items.map((i) => (i as BudgetItemModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
