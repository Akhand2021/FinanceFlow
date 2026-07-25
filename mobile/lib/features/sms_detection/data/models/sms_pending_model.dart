import '../../domain/entities/sms_pending_entity.dart';

class SmsPendingModel extends SmsPendingEntity {
  const SmsPendingModel({
    required super.id,
    required super.userId,
    required super.smsContent,
    super.extractedMerchant,
    super.extractedAmount,
    super.extractedDate,
    super.extractedAccount,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SmsPendingModel.fromJson(Map<String, dynamic> json) {
    return SmsPendingModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      smsContent: json['smsContent'] ?? '',
      extractedMerchant: json['extractedMerchant'],
      extractedAmount: (json['extractedAmount'] as num?)?.toDouble(),
      extractedDate: json['extractedDate'] != null
          ? DateTime.parse(json['extractedDate'])
          : null,
      extractedAccount: json['extractedAccount'],
      status: json['status'] ?? 'PENDING',
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
      'smsContent': smsContent,
      'extractedMerchant': extractedMerchant,
      'extractedAmount': extractedAmount,
      'extractedDate': extractedDate?.toIso8601String(),
      'extractedAccount': extractedAccount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
