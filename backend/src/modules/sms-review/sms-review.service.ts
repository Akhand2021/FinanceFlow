import { Injectable } from '@nestjs/common';
import { SmsReviewRepository } from './sms-review.repository';
import { IngestSmsDto } from './dto/ingest-sms.dto';
import { ProcessSmsDto } from './dto/process-sms.dto';
import { SmsPendingEntity } from './entities/sms-pending.entity';
import { NotFoundException } from '@common/exceptions/api.exception';

@Injectable()
export class SmsReviewService {
  constructor(private readonly smsReviewRepository: SmsReviewRepository) {}

  async getPendingSms(userId: string): Promise<SmsPendingEntity[]> {
    return this.smsReviewRepository.findAllPendingByUserId(userId);
  }

  async ingestSms(userId: string, dto: IngestSmsDto): Promise<SmsPendingEntity> {
    return this.smsReviewRepository.ingestSms(userId, dto);
  }

  async processSms(
    id: string,
    userId: string,
    dto: ProcessSmsDto,
  ): Promise<SmsPendingEntity> {
    const existing = await this.smsReviewRepository.findById(id, userId);
    if (!existing) {
      throw new NotFoundException('SMS pending record');
    }
    return this.smsReviewRepository.processSms(id, userId, dto);
  }
}
