import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsBoolean,
  IsEnum,
  IsArray,
  IsDateString,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum TransactionType {
  INCOME = 'INCOME',
  EXPENSE = 'EXPENSE',
  TRANSFER = 'TRANSFER',
}

export class CreateTransactionDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @IsString()
  @IsNotEmpty()
  accountId!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  @IsString()
  @IsNotEmpty()
  categoryId!: string;

  @ApiProperty({ enum: TransactionType, example: TransactionType.EXPENSE })
  @IsEnum(TransactionType)
  type!: TransactionType;

  @ApiProperty({ example: 450.0 })
  @IsNumber()
  @Min(0.01)
  amount!: number;

  @ApiPropertyOptional({ example: 'Swiggy Food Delivery' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({ example: 'Swiggy' })
  @IsString()
  @IsOptional()
  merchant?: string;

  @ApiPropertyOptional({
    description: 'Target account for TRANSFER transactions',
    example: '550e8400-e29b-41d4-a716-446655440002',
  })
  @IsString()
  @IsOptional()
  toAccountId?: string;

  @ApiPropertyOptional({ example: '2026-07-25T12:00:00Z' })
  @IsDateString()
  date!: string;

  @ApiPropertyOptional({ default: false })
  @IsBoolean()
  @IsOptional()
  isPending?: boolean;

  @ApiPropertyOptional({ default: false })
  @IsBoolean()
  @IsOptional()
  isRecurring?: boolean;

  @ApiPropertyOptional({ example: 'MONTHLY' })
  @IsString()
  @IsOptional()
  recurringPattern?: string;

  @ApiPropertyOptional({ example: ['food', 'lunch'], type: [String] })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  tags?: string[];

  @ApiPropertyOptional({ example: 'Lunch with team' })
  @IsString()
  @IsOptional()
  notes?: string;
}
