import '../../domain/entities/user_settings_entity.dart';

class UserSettingsModel extends UserSettingsEntity {
  const UserSettingsModel({
    required super.id,
    required super.email,
    super.phone,
    required super.firstName,
    required super.lastName,
    super.profilePicture,
    required super.currency,
    required super.language,
    required super.theme,
    required super.pinnedLocked,
    required super.biometricLocked,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profilePicture: json['profilePicture'],
      currency: json['currency'] ?? 'USD',
      language: json['language'] ?? 'en',
      theme: json['theme'] ?? 'light',
      pinnedLocked: json['pinnedLocked'] ?? false,
      biometricLocked: json['biometricLocked'] ?? false,
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
      'email': email,
      'phone': phone,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
      'currency': currency,
      'language': language,
      'theme': theme,
      'pinnedLocked': pinnedLocked,
      'biometricLocked': biometricLocked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
