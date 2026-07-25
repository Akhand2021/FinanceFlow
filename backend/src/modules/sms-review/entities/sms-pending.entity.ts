export class SmsPendingEntity {
  id!: string;
  userId!: string;
  smsContent!: string;
  extractedMerchant?: string | null;
  extractedAmount?: number | null;
  extractedDate?: Date | null;
  extractedAccount?: string | null;
  status!: string; // PENDING, ACCEPTED, REJECTED, IGNORED
  createdAt!: Date;
  updatedAt!: Date;

  constructor(partial: Partial<SmsPendingEntity>) {
    Object.assign(this, partial);
  }
}
