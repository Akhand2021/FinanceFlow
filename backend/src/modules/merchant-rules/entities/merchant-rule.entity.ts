export class MerchantRuleEntity {
  id!: string;
  userId!: string;
  merchantName!: string;
  categoryId!: string;
  confidence!: number;
  category?: any;

  constructor(partial: Partial<MerchantRuleEntity>) {
    Object.assign(this, partial);
  }
}
