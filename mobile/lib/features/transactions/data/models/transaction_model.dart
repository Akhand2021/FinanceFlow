import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.accountId,
    required super.categoryId,
    required super.type,
    required super.amount,
    super.description,
    super.merchant,
    super.toAccountId,
    super.receiptId,
    required super.isPending,
    required super.isRecurring,
    required super.tags,
    super.notes,
    required super.date,
    required super.createdAt,
    required super.updatedAt,
    super.account,
    super.category,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      accountId: json['accountId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      type: json['type'] ?? 'EXPENSE',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'],
      merchant: json['merchant'],
      toAccountId: json['toAccountId'],
      receiptId: json['receiptId'],
      isPending: json['isPending'] ?? false,
      isRecurring: json['isRecurring'] ?? false,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      notes: json['notes'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      account: json['account'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'categoryId': categoryId,
      'type': type,
      'amount': amount,
      'description': description,
      'merchant': merchant,
      'toAccountId': toAccountId,
      'receiptId': receiptId,
      'isPending': isPending,
      'isRecurring': isRecurring,
      'tags': tags,
      'notes': notes,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
