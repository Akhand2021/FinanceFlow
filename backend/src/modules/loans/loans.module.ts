import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { LoansController } from './loans.controller';
import { LoansService } from './loans.service';
import { LoansRepository } from './loans.repository';

@Module({
  imports: [DatabaseModule, CommonModule],
  controllers: [LoansController],
  providers: [LoansService, LoansRepository],
  exports: [LoansService, LoansRepository],
})
export class LoansModule {}
