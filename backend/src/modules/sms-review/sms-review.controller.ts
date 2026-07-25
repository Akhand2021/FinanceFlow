import {
  Controller,
  Get,
  Post,
  Body,
  Param,
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
import { SmsReviewService } from './sms-review.service';
import { IngestSmsDto } from './dto/ingest-sms.dto';
import { ProcessSmsDto } from './dto/process-sms.dto';
import { SmsPendingResponseDto } from './dto/sms-pending-response.dto';

@ApiTags('SMS Banking Detection')
@Controller('sms-pending')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class SmsReviewController {
  constructor(private readonly smsReviewService: SmsReviewService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all pending SMS transactions awaiting review' })
  @ApiResponse({
    status: 200,
    type: [SmsPendingResponseDto],
  })
  async getPendingSms(@CurrentUser() user: any): Promise<SmsPendingResponseDto[]> {
    return this.smsReviewService.getPendingSms(user.sub);
  }

  @Post('ingest')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Ingest detected banking SMS from Android background broadcast' })
  @ApiResponse({
    status: 201,
    description: 'SMS stored in user review queue',
    type: SmsPendingResponseDto,
  })
  async ingestSms(
    @CurrentUser() user: any,
    @Body() dto: IngestSmsDto,
  ): Promise<SmsPendingResponseDto> {
    return this.smsReviewService.ingestSms(user.sub, dto);
  }

  @Post(':id/process')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Process pending SMS transaction (ACCEPT, REJECT, IGNORE)' })
  @ApiResponse({
    status: 200,
    description: 'SMS processed and real Transaction created if ACCEPTED',
    type: SmsPendingResponseDto,
  })
  async processSms(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: ProcessSmsDto,
  ): Promise<SmsPendingResponseDto> {
    return this.smsReviewService.processSms(id, user.sub, dto);
  }
}
