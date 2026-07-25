export class LoanPaymentEntity {
  id!: string;
  loanId!: string;
  accountId!: string;
  amount!: number;
  principalAmount?: number | null;
  interestAmount?: number | null;
  note?: string | null;
  dueDate?: Date | null;
  paidDate?: Date | null;
  isPaid!: boolean;
  createdAt!: Date;
  updatedAt!: Date;

  constructor(partial: Partial<LoanPaymentEntity>) {
    Object.assign(this, partial);
  }
}

export class LoanEntity {
  id!: string;
  userId!: string;
  name!: string;
  type!: string; // HOME_LOAN, CAR_LOAN, PERSONAL_LOAN, CREDIT_CARD, BORROWED, LENT
  lender?: string | null;
  principal!: number;
  currentAmount!: number;
  interestRate!: number;
  emiAmount?: number | null;
  startDate!: Date;
  endDate?: Date | null;
  isActive!: boolean;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;
  payments!: LoanPaymentEntity[];

  constructor(partial: Partial<LoanEntity>) {
    Object.assign(this, partial);
  }
}
