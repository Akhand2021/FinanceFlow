import { Injectable } from '@nestjs/common';
import { ReportsRepository } from './reports.repository';
import { ReportsQueryDto } from './dto/reports-query.dto';
import { ReportsSummaryResponseDto } from './dto/reports-summary-response.dto';
import { FinancialHealthScoreEntity } from './entities/financial-health-score.entity';

@Injectable()
export class ReportsService {
  constructor(private readonly reportsRepository: ReportsRepository) {}

  async getReportsSummary(
    userId: string,
    query: ReportsQueryDto,
  ): Promise<ReportsSummaryResponseDto> {
    return this.reportsRepository.getReportsSummary(userId, query);
  }

  async getFinancialHealthScore(
    userId: string,
  ): Promise<FinancialHealthScoreEntity> {
    return this.reportsRepository.calculateFinancialHealthScore(userId);
  }
}
