export class UserEntity {
  id!: string;
  email!: string;
  phone?: string | null;
  firstName!: string;
  lastName!: string;
  profilePicture?: string | null;
  currency!: string;
  language!: string;
  theme!: string;
  pinnedLocked!: boolean;
  biometricLocked!: boolean;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;

  constructor(partial: Partial<UserEntity>) {
    Object.assign(this, partial);
  }
}
