import '../../domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  const AccountModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    required super.balance,
    required super.currency,
    super.bankName,
    super.accountNumber,
    super.routingNumber,
    required super.isDefault,
    super.color,
    super.icon,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'BANK',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      routingNumber: json['routingNumber'],
      isDefault: json['isDefault'] ?? false,
      color: json['color'],
      icon: json['icon'],
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
      'balance': balance,
      'currency': currency,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'routingNumber': routingNumber,
      'isDefault': isDefault,
      'color': color,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
