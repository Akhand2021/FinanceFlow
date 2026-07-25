import '../../domain/entities/saving_goal_entity.dart';

class GoalContributionModel extends GoalContributionEntity {
  const GoalContributionModel({
    required super.id,
    required super.goalId,
    required super.amount,
    super.note,
    required super.createdAt,
  });

  factory GoalContributionModel.fromJson(Map<String, dynamic> json) {
    return GoalContributionModel(
      id: json['id'] ?? '',
      goalId: json['goalId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalId': goalId,
      'amount': amount,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class SavingGoalModel extends SavingGoalEntity {
  const SavingGoalModel({
    required super.id,
    required super.userId,
    required super.name,
    super.description,
    required super.targetAmount,
    required super.currentAmount,
    super.icon,
    super.color,
    super.targetDate,
    required super.priority,
    required super.isActive,
    required super.contributions,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SavingGoalModel.fromJson(Map<String, dynamic> json) {
    final rawContribs = json['contributions'] as List? ?? [];
    return SavingGoalModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'],
      color: json['color'],
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'])
          : null,
      priority: json['priority'] ?? 'MEDIUM',
      isActive: json['isActive'] ?? true,
      contributions: rawContribs
          .map((c) => GoalContributionModel.fromJson(c))
          .toList(),
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
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'icon': icon,
      'color': color,
      'targetDate': targetDate?.toIso8601String(),
      'priority': priority,
      'isActive': isActive,
      'contributions':
          contributions.map((c) => (c as GoalContributionModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
