import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { TransactionsController } from './transactions.controller';
import { TransactionsService } from './transactions.service';
import { TransactionsRepository } from './transactions.repository';

@Module({
  imports: [DatabaseModule, CommonModule],
  controllers: [TransactionsController],
  providers: [TransactionsService, TransactionsRepository],
  exports: [TransactionsService, TransactionsRepository],
})
export class TransactionsModule {}
