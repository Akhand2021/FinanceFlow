import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsEnum,
  IsDateString,
  Min,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum GoalPriority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
}

export class CreateGoalDto {
  @ApiProperty({ example: 'Emergency Fund' })
  @IsString()
  @IsNotEmpty()
  name!: string;

  @ApiPropertyOptional({ example: '6 months of living expenses' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ example: 10000.0 })
  @IsNumber()
  @Min(0.01)
  targetAmount!: number;

  @ApiPropertyOptional({ example: 1000.0, default: 0 })
  @IsNumber()
  @Min(0)
  @IsOptional()
  currentAmount?: number;

  @ApiPropertyOptional({ example: 'shield_icon' })
  @IsString()
  @IsOptional()
  icon?: string;

  @ApiPropertyOptional({ example: '0xFF2ECC71' })
  @IsString()
  @IsOptional()
  color?: string;

  @ApiPropertyOptional({ example: '2026-12-31T00:00:00.000Z' })
  @IsDateString()
  @IsOptional()
  targetDate?: string;

  @ApiPropertyOptional({ enum: GoalPriority, default: GoalPriority.MEDIUM })
  @IsEnum(GoalPriority)
  @IsOptional()
  priority?: GoalPriority;
}
