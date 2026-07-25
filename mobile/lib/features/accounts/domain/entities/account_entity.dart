import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String type; // BANK, CREDIT_CARD, DIGITAL_WALLET, CASH, UPI, INVESTMENT
  final double balance;
  final String currency;
  final String? bankName;
  final String? accountNumber;
  final String? routingNumber;
  final bool isDefault;
  final String? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccountEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.balance,
    required this.currency,
    this.bankName,
    this.accountNumber,
    this.routingNumber,
    required this.isDefault,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        balance,
        currency,
        bankName,
        accountNumber,
        routingNumber,
        isDefault,
        color,
        icon,
        createdAt,
        updatedAt,
      ];
}
