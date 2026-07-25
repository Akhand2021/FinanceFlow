import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AccountType } from './create-account.dto';

export class AccountResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'HDFC Bank Primary' })
  name!: string;

  @ApiProperty({ enum: AccountType, example: AccountType.BANK })
  type!: string;

  @ApiProperty({ example: 10000.0 })
  balance!: number;

  @ApiProperty({ example: 'USD' })
  currency!: string;

  @ApiPropertyOptional({ example: 'HDFC Bank' })
  bankName?: string | null;

  @ApiPropertyOptional({ example: '****1234' })
  accountNumber?: string | null;

  @ApiPropertyOptional({ example: 'HDFC0001234' })
  routingNumber?: string | null;

  @ApiProperty({ example: false })
  isDefault!: boolean;

  @ApiPropertyOptional({ example: '0xFF6C63FF' })
  color?: string | null;

  @ApiPropertyOptional({ example: 'bank_icon' })
  icon?: string | null;

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
