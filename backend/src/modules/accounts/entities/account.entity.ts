export class AccountEntity {
  id!: string;
  userId!: string;
  name!: string;
  type!: string; // BANK, CREDIT_CARD, DIGITAL_WALLET, CASH, UPI, INVESTMENT
  balance!: number;
  currency!: string;
  bankName?: string | null;
  accountNumber?: string | null;
  routingNumber?: string | null;
  isDefault!: boolean;
  color?: string | null;
  icon?: string | null;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;

  constructor(partial: Partial<AccountEntity>) {
    Object.assign(this, partial);
  }
}
