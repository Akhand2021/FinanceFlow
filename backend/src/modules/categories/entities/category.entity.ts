export class CategoryEntity {
  id!: string;
  userId!: string;
  name!: string;
  type!: string; // INCOME, EXPENSE, TRANSFER
  icon?: string | null;
  color?: string | null;
  isDefault!: boolean;
  isActive!: boolean;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;

  constructor(partial: Partial<CategoryEntity>) {
    Object.assign(this, partial);
  }
}
