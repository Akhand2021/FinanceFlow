export class BudgetItemEntity {
  id!: string;
  budgetId!: string;
  categoryId!: string;
  limitAmount!: number;
  spent!: number;
  category?: any;

  constructor(partial: Partial<BudgetItemEntity>) {
    Object.assign(this, partial);
  }
}

export class BudgetEntity {
  id!: string;
  userId!: string;
  name!: string;
  amount!: number;
  month!: Date;
  isActive!: boolean;
  alertThreshold!: number;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;
  items!: BudgetItemEntity[];

  constructor(partial: Partial<BudgetEntity>) {
    Object.assign(this, partial);
  }
}
