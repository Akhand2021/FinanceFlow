import 'package:equatable/equatable.dart';

class LoanPaymentEntity extends Equatable {
  final String id;
  final String loanId;
  final String accountId;
  final double amount;
  final double? principalAmount;
  final double? interestAmount;
  final String? note;
  final DateTime? dueDate;
  final DateTime? paidDate;
  final bool isPaid;
  final DateTime createdAt;

  const LoanPaymentEntity({
    required this.id,
    required this.loanId,
    required this.accountId,
    required this.amount,
    this.principalAmount,
    this.interestAmount,
    this.note,
    this.dueDate,
    this.paidDate,
    required this.isPaid,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        loanId,
        accountId,
        amount,
        principalAmount,
        interestAmount,
        note,
        dueDate,
        paidDate,
        isPaid,
        createdAt,
      ];
}

class LoanEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String type; // HOME_LOAN, CAR_LOAN, PERSONAL_LOAN, CREDIT_CARD, BORROWED, LENT
  final String? lender;
  final double principal;
  final double currentAmount;
  final double interestRate;
  final double? emiAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final List<LoanPaymentEntity> payments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LoanEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.lender,
    required this.principal,
    required this.currentAmount,
    required this.interestRate,
    this.emiAmount,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.payments,
    required this.createdAt,
    required this.updatedAt,
  });

  double get paidAmount => principal - currentAmount;
  double get progressPercentage {
    if (principal <= 0) return 0.0;
    final pct = ((principal - currentAmount) / principal) * 100;
    return pct > 100 ? 100.0 : (pct < 0 ? 0.0 : pct);
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        lender,
        principal,
        currentAmount,
        interestRate,
        emiAmount,
        startDate,
        endDate,
        isActive,
        payments,
        createdAt,
        updatedAt,
      ];
}
