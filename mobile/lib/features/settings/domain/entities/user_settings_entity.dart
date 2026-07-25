import 'package:equatable/equatable.dart';

class UserSettingsEntity extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String currency;
  final String language;
  final String theme;
  final bool pinnedLocked;
  final bool biometricLocked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSettingsEntity({
    required this.id,
    required this.email,
    this.phone,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    required this.currency,
    required this.language,
    required this.theme,
    required this.pinnedLocked,
    required this.biometricLocked,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        phone,
        firstName,
        lastName,
        profilePicture,
        currency,
        language,
        theme,
        pinnedLocked,
        biometricLocked,
        createdAt,
        updatedAt,
      ];
}
