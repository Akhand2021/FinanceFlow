import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsArray,
  ValidateNested,
  IsDateString,
  Min,
  Max,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateBudgetItemDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  @IsString()
  @IsNotEmpty()
  categoryId!: string;

  @ApiProperty({ example: 1000.0 })
  @IsNumber()
  @Min(0.01)
  limitAmount!: number;
}

export class CreateBudgetDto {
  @ApiProperty({ example: 'July 2026 Monthly Budget' })
  @IsString()
  @IsNotEmpty()
  name!: string;

  @ApiProperty({ example: 5000.0 })
  @IsNumber()
  @Min(0.01)
  amount!: number;

  @ApiProperty({ example: '2026-07-01T00:00:00.000Z' })
  @IsDateString()
  month!: string;

  @ApiPropertyOptional({ example: 80, default: 80 })
  @IsNumber()
  @Min(1)
  @Max(100)
  @IsOptional()
  alertThreshold?: number;

  @ApiPropertyOptional({ type: [CreateBudgetItemDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateBudgetItemDto)
  @IsOptional()
  items?: CreateBudgetItemDto[];
}
