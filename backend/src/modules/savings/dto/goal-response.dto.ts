import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { GoalPriority } from './create-goal.dto';

export class GoalContributionResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  goalId!: string;

  @ApiProperty({ example: 500.0 })
  amount!: number;

  @ApiPropertyOptional({ example: 'July contribution' })
  note?: string | null;

  @ApiProperty()
  createdAt!: Date;
}

export class GoalResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'Emergency Fund' })
  name!: string;

  @ApiPropertyOptional({ example: '6 months living expenses' })
  description?: string | null;

  @ApiProperty({ example: 10000.0 })
  targetAmount!: number;

  @ApiProperty({ example: 2500.0 })
  currentAmount!: number;

  @ApiPropertyOptional({ example: 'shield_icon' })
  icon?: string | null;

  @ApiPropertyOptional({ example: '0xFF2ECC71' })
  color?: string | null;

  @ApiPropertyOptional()
  targetDate?: Date | null;

  @ApiProperty({ enum: GoalPriority, example: GoalPriority.MEDIUM })
  priority!: string;

  @ApiProperty({ example: true })
  isActive!: boolean;

  @ApiProperty({ type: [GoalContributionResponseDto] })
  contributions!: GoalContributionResponseDto[];

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
