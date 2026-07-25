import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { TransactionType } from './create-transaction.dto';

export class TransactionResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440002' })
  accountId!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440003' })
  categoryId!: string;

  @ApiProperty({ enum: TransactionType, example: TransactionType.EXPENSE })
  type!: string;

  @ApiProperty({ example: 450.0 })
  amount!: number;

  @ApiPropertyOptional({ example: 'Swiggy Food Delivery' })
  description?: string | null;

  @ApiPropertyOptional({ example: 'Swiggy' })
  merchant?: string | null;

  @ApiPropertyOptional()
  toAccountId?: string | null;

  @ApiPropertyOptional()
  receiptId?: string | null;

  @ApiProperty({ example: false })
  isPending!: boolean;

  @ApiProperty({ example: false })
  isRecurring!: boolean;

  @ApiPropertyOptional({ example: ['food'] })
  tags!: string[];

  @ApiPropertyOptional({ example: 'Lunch' })
  notes?: string | null;

  @ApiProperty()
  date!: Date;

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;

  @ApiPropertyOptional()
  account?: any;

  @ApiPropertyOptional()
  category?: any;
}
