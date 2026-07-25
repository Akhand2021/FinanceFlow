import {
  Controller,
  Get,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtGuard } from '@common/guards/jwt.guard';
import { CurrentUser } from '@common/decorators/current-user.decorator';
import { ReportsService } from './reports.service';
import { ReportsQueryDto } from './dto/reports-query.dto';
import { ReportsSummaryResponseDto } from './dto/reports-summary-response.dto';
import { FinancialHealthScoreResponseDto } from './dto/financial-health-score-response.dto';

@ApiTags('Reports & Analytics')
@Controller('reports')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class ReportsController {
  constructor(private readonly reportsService: ReportsService) {}

  @Get('summary')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Get Net Worth, Cash Flow, and Category Expense Breakdown',
  })
  @ApiResponse({
    status: 200,
    type: ReportsSummaryResponseDto,
  })
  async getSummary(
    @CurrentUser() user: any,
    @Query() query: ReportsQueryDto,
  ): Promise<ReportsSummaryResponseDto> {
    return this.reportsService.getReportsSummary(user.sub, query);
  }

  @Get('health-score')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Compute 0-100 Financial Health Score & personalized recommendations',
  })
  @ApiResponse({
    status: 200,
    type: FinancialHealthScoreResponseDto,
  })
  async getHealthScore(
    @CurrentUser() user: any,
  ): Promise<FinancialHealthScoreResponseDto> {
    return this.reportsService.getFinancialHealthScore(user.sub);
  }
}
