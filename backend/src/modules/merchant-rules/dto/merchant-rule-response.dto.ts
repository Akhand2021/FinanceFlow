import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class MerchantRuleResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'Swiggy' })
  merchantName!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440002' })
  categoryId!: string;

  @ApiProperty({ example: 0.9 })
  confidence!: number;

  @ApiPropertyOptional()
  category?: any;
}
