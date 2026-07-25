import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CategoryType } from './create-category.dto';

export class CategoryResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'Food & Dining' })
  name!: string;

  @ApiProperty({ enum: CategoryType, example: CategoryType.EXPENSE })
  type!: string;

  @ApiPropertyOptional({ example: 'food_icon' })
  icon?: string | null;

  @ApiPropertyOptional({ example: '0xFF8E8DFF' })
  color?: string | null;

  @ApiProperty({ example: true })
  isDefault!: boolean;

  @ApiProperty({ example: true })
  isActive!: boolean;

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
