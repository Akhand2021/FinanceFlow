import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsDateString,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class IngestSmsDto {
  @ApiProperty({
    description: 'Raw SMS content received on Android',
    example: 'Rs 450.00 debited from a/c **1234 on 25-JUL-26 at SWIGGY',
  })
  @IsString()
  @IsNotEmpty()
  smsContent!: string;

  @ApiPropertyOptional({ example: 'Swiggy' })
  @IsString()
  @IsOptional()
  extractedMerchant?: string;

  @ApiPropertyOptional({ example: 450.0 })
  @IsNumber()
  @Min(0.01)
  @IsOptional()
  extractedAmount?: number;

  @ApiPropertyOptional({ example: '2026-07-25T12:00:00.000Z' })
  @IsDateString()
  @IsOptional()
  extractedDate?: string;

  @ApiPropertyOptional({ example: 'HDFC Bank ****1234' })
  @IsString()
  @IsOptional()
  extractedAccount?: string;
}
