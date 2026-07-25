import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsDateString,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RecordPaymentDto {
  @ApiProperty({
    description: 'Account ID to deduct payment from',
    example: '550e8400-e29b-41d4-a716-446655440001',
  })
  @IsString()
  @IsNotEmpty()
  accountId!: string;

  @ApiProperty({ example: 4500.0, description: 'Total EMI payment amount' })
  @IsNumber()
  @Min(0.01)
  amount!: number;

  @ApiPropertyOptional({ example: 3500.0, description: 'Principal component of EMI' })
  @IsNumber()
  @Min(0)
  @IsOptional()
  principalAmount?: number;

  @ApiPropertyOptional({ example: 1000.0, description: 'Interest component of EMI' })
  @IsNumber()
  @Min(0)
  @IsOptional()
  interestAmount?: number;

  @ApiPropertyOptional({ example: 'July 2026 EMI payment' })
  @IsString()
  @IsOptional()
  note?: string;

  @ApiPropertyOptional({ example: '2026-07-25T00:00:00.000Z' })
  @IsDateString()
  @IsOptional()
  paidDate?: string;
}
