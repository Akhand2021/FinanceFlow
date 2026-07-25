import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final String type; // INCOME, EXPENSE, TRANSFER
  final double amount;
  final String? description;
  final String? merchant;
  final String? toAccountId;
  final String? receiptId;
  final bool isPending;
  final bool isRecurring;
  final List<String> tags;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic account;
  final dynamic category;

  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.amount,
    this.description,
    this.merchant,
    this.toAccountId,
    this.receiptId,
    required this.isPending,
    required this.isRecurring,
    required this.tags,
    this.notes,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.account,
    this.category,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        accountId,
        categoryId,
        type,
        amount,
        description,
        merchant,
        toAccountId,
        receiptId,
        isPending,
        isRecurring,
        tags,
        notes,
        date,
        createdAt,
        updatedAt,
        account,
        category,
      ];
}
