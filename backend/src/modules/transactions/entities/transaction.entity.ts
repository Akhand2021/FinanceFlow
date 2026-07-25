export class TransactionEntity {
  id!: string;
  userId!: string;
  accountId!: string;
  categoryId!: string;
  type!: string; // INCOME, EXPENSE, TRANSFER
  amount!: number;
  description?: string | null;
  merchant?: string | null;
  toAccountId?: string | null;
  receiptId?: string | null;
  isPending!: boolean;
  isRecurring!: boolean;
  recurringPattern?: string | null;
  tags!: string[];
  notes?: string | null;
  date!: Date;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;

  account?: any;
  toAccount?: any;
  category?: any;

  constructor(partial: Partial<TransactionEntity>) {
    Object.assign(this, partial);
  }
}
