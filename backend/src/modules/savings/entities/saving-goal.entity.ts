export class GoalContributionEntity {
  id!: string;
  goalId!: string;
  amount!: number;
  note?: string | null;
  createdAt!: Date;

  constructor(partial: Partial<GoalContributionEntity>) {
    Object.assign(this, partial);
  }
}

export class SavingGoalEntity {
  id!: string;
  userId!: string;
  name!: string;
  description?: string | null;
  targetAmount!: number;
  currentAmount!: number;
  icon?: string | null;
  color?: string | null;
  targetDate?: Date | null;
  priority!: string; // LOW, MEDIUM, HIGH
  isActive!: boolean;
  createdAt!: Date;
  updatedAt!: Date;
  deletedAt?: Date | null;
  contributions!: GoalContributionEntity[];

  constructor(partial: Partial<SavingGoalEntity>) {
    Object.assign(this, partial);
  }
}
