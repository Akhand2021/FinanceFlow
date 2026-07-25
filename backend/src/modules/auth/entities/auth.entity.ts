export class AuthEntity {
  userId!: string;
  email!: string;
  passwordHash!: string;
  isEmailVerified!: boolean;
  lastLogin?: Date | null;

  constructor(partial: Partial<AuthEntity>) {
    Object.assign(this, partial);
  }
}
