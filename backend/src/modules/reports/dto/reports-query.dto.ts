import { IsOptional, IsString, IsDateString } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class ReportsQueryDto {
  @ApiPropertyOptional({ description: 'Start date for report calculations' })
  @IsDateString()
  @IsOptional()
  startDate?: string;

  @ApiPropertyOptional({ description: 'End date for report calculations' })
  @IsDateString()
  @IsOptional()
  endDate?: string;

  @ApiPropertyOptional({ example: 'MONTHLY' })
  @IsString()
  @IsOptional()
  period?: string = 'MONTHLY';
}
