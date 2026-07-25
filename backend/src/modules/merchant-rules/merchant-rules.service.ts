import { Injectable } from '@nestjs/common';
import { MerchantRulesRepository } from './merchant-rules.repository';
import { CreateMerchantRuleDto } from './dto/create-merchant-rule.dto';
import { MerchantRuleEntity } from './entities/merchant-rule.entity';

@Injectable()
export class MerchantRulesService {
  constructor(private readonly repository: MerchantRulesRepository) {}

  async getUserRules(userId: string): Promise<MerchantRuleEntity[]> {
    return this.repository.findAllByUserId(userId);
  }

  async getRuleByMerchant(userId: string, merchantName: string): Promise<MerchantRuleEntity | null> {
    return this.repository.findByMerchantName(userId, merchantName);
  }

  async upsertRule(userId: string, dto: CreateMerchantRuleDto): Promise<MerchantRuleEntity> {
    return this.repository.upsertRule(userId, dto);
  }

  async deleteRule(id: string, userId: string): Promise<void> {
    await this.repository.delete(id, userId);
  }
}
