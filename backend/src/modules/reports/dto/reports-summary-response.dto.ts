import { ApiProperty } from '@nestjs/swagger';

export class CategoryBreakdownItemDto {
  @ApiProperty({ example: 'Food' })
  categoryName!: string;

  @ApiProperty({ example: '0xFFFF6B6B' })
  color!: string;

  @ApiProperty({ example: 12500.0 })
  amount!: number;

  @ApiProperty({ example: 32.5 })
  percentage!: number;
}

export class ReportsSummaryResponseDto {
  @ApiProperty({ example: 245680.5 })
  netWorth!: number;

  @ApiProperty({ example: 450000.0 })
  totalAssets!: number;

  @ApiProperty({ example: 204319.5 })
  totalLiabilities!: number;

  @ApiProperty({ example: 85000.0 })
  totalIncome!: number;

  @ApiProperty({ example: 42530.0 })
  totalExpense!: number;

  @ApiProperty({ example: 42470.0 })
  netSavings!: number;

  @ApiProperty({ type: [CategoryBreakdownItemDto] })
  categoryBreakdown!: CategoryBreakdownItemDto[];
}
