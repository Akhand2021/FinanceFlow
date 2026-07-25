export class UserSettingsEntity {
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

  constructor(partial: Partial<UserSettingsEntity>) {
    Object.assign(this, partial);
  }
}
