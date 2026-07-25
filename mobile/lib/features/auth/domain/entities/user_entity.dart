import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
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

  const UserEntity({
    required this.id,
    required this.email,
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

  UserEntity copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? profilePicture,
    String? currency,
    String? language,
    String? theme,
    bool? pinnedLocked,
    bool? biometricLocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      pinnedLocked: pinnedLocked ?? this.pinnedLocked,
      biometricLocked: biometricLocked ?? this.biometricLocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
