import { Module } from '@nestjs/common';
import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { SmsReviewController } from './sms-review.controller';
import { SmsReviewService } from './sms-review.service';
import { SmsReviewRepository } from './sms-review.repository';

@Module({
  imports: [DatabaseModule, CommonModule],
  controllers: [SmsReviewController],
  providers: [SmsReviewService, SmsReviewRepository],
  exports: [SmsReviewService, SmsReviewRepository],
})
export class SmsReviewModule {}
