import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class SmsPendingResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'Rs 450.00 debited from a/c **1234 on 25-JUL-26 at SWIGGY' })
  smsContent!: string;

  @ApiPropertyOptional({ example: 'Swiggy' })
  extractedMerchant?: string | null;

  @ApiPropertyOptional({ example: 450.0 })
  extractedAmount?: number | null;

  @ApiPropertyOptional()
  extractedDate?: Date | null;

  @ApiPropertyOptional({ example: 'HDFC Bank ****1234' })
  extractedAccount?: string | null;

  @ApiProperty({ example: 'PENDING' })
  status!: string;

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
