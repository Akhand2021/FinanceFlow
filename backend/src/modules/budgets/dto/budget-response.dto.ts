import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class BudgetItemResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  budgetId!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440002' })
  categoryId!: string;

  @ApiProperty({ example: 1000.0 })
  limitAmount!: number;

  @ApiProperty({ example: 450.0 })
  spent!: number;

  @ApiPropertyOptional()
  category?: any;
}

export class BudgetResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'July 2026 Monthly Budget' })
  name!: string;

  @ApiProperty({ example: 5000.0 })
  amount!: number;

  @ApiProperty({ example: '2026-07-01T00:00:00.000Z' })
  month!: Date;

  @ApiProperty({ example: true })
  isActive!: boolean;

  @ApiProperty({ example: 80 })
  alertThreshold!: number;

  @ApiProperty({ type: [BudgetItemResponseDto] })
  items!: BudgetItemResponseDto[];

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
