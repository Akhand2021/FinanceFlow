import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { SavingsController } from './savings.controller';
import { SavingsService } from './savings.service';
import { SavingsRepository } from './savings.repository';

@Module({
  imports: [DatabaseModule, CommonModule],
  controllers: [SavingsController],
  providers: [SavingsService, SavingsRepository],
  exports: [SavingsService, SavingsRepository],
})
export class SavingsModule {}
