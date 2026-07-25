import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
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

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.currency = 'USD',
    this.language = 'en',
    this.theme = 'light',
    this.pinnedLocked = false,
    this.biometricLocked = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
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

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      currency: currency,
      language: language,
      theme: theme,
      pinnedLocked: pinnedLocked,
      biometricLocked: biometricLocked,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
