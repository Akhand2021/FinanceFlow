import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { MerchantRulesController } from './merchant-rules.controller';
import { MerchantRulesService } from './merchant-rules.service';
import { MerchantRulesRepository } from './merchant-rules.repository';

@Module({
  imports: [DatabaseModule, CommonModule],
  controllers: [MerchantRulesController],
  providers: [MerchantRulesService, MerchantRulesRepository],
  exports: [MerchantRulesService, MerchantRulesRepository],
})
export class MerchantRulesModule {}
