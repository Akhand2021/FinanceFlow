import 'package:equatable/equatable.dart';

class SmsPendingEntity extends Equatable {
  final String id;
  final String userId;
  final String smsContent;
  final String? extractedMerchant;
  final double? extractedAmount;
  final DateTime? extractedDate;
  final String? extractedAccount;
  final String status; // PENDING, ACCEPTED, REJECTED, IGNORED
  final DateTime createdAt;
  final DateTime updatedAt;

  const SmsPendingEntity({
    required this.id,
    required this.userId,
    required this.smsContent,
    this.extractedMerchant,
    this.extractedAmount,
    this.extractedDate,
    this.extractedAccount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        smsContent,
        extractedMerchant,
        extractedAmount,
        extractedDate,
        extractedAccount,
        status,
        createdAt,
        updatedAt,
      ];
}
