import '../../domain/entities/loan_entity.dart';

class LoanPaymentModel extends LoanPaymentEntity {
  const LoanPaymentModel({
    required super.id,
    required super.loanId,
    required super.accountId,
    required super.amount,
    super.principalAmount,
    super.interestAmount,
    super.note,
    super.dueDate,
    super.paidDate,
    required super.isPaid,
    required super.createdAt,
  });

  factory LoanPaymentModel.fromJson(Map<String, dynamic> json) {
    return LoanPaymentModel(
      id: json['id'] ?? '',
      loanId: json['loanId'] ?? '',
      accountId: json['accountId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      principalAmount: (json['principalAmount'] as num?)?.toDouble(),
      interestAmount: (json['interestAmount'] as num?)?.toDouble(),
      note: json['note'],
      dueDate:
          json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      paidDate:
          json['paidDate'] != null ? DateTime.parse(json['paidDate']) : null,
      isPaid: json['isPaid'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanId': loanId,
      'accountId': accountId,
      'amount': amount,
      'principalAmount': principalAmount,
      'interestAmount': interestAmount,
      'note': note,
      'dueDate': dueDate?.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'isPaid': isPaid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class LoanModel extends LoanEntity {
  const LoanModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    super.lender,
    required super.principal,
    required super.currentAmount,
    required super.interestRate,
    super.emiAmount,
    required super.startDate,
    super.endDate,
    required super.isActive,
    required super.payments,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    final rawPayments = json['payments'] as List? ?? [];
    return LoanModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'PERSONAL_LOAN',
      lender: json['lender'],
      principal: (json['principal'] as num?)?.toDouble() ?? 0.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
      emiAmount: (json['emiAmount'] as num?)?.toDouble(),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate:
          json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isActive: json['isActive'] ?? true,
      payments:
          rawPayments.map((p) => LoanPaymentModel.fromJson(p)).toList(),
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
      'type': type,
      'lender': lender,
      'principal': principal,
      'currentAmount': currentAmount,
      'interestRate': interestRate,
      'emiAmount': emiAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'payments':
          payments.map((p) => (p as LoanPaymentModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
