import {
  IsString,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsBoolean,
  IsEnum,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum AccountType {
  BANK = 'BANK',
  CHECKING = 'CHECKING',
  SAVINGS = 'SAVINGS',
  CREDIT_CARD = 'CREDIT_CARD',
  DIGITAL_WALLET = 'DIGITAL_WALLET',
  CASH = 'CASH',
  UPI = 'UPI',
  INVESTMENT = 'INVESTMENT',
}

export class CreateAccountDto {
  @ApiProperty({
    description: 'Account display name',
    example: 'HDFC Bank Primary',
  })
  @IsString()
  @IsNotEmpty()
  name!: string;

  @ApiProperty({
    description: 'Type of account',
    enum: AccountType,
    example: AccountType.BANK,
  })
  @IsEnum(AccountType)
  type!: AccountType;

  @ApiPropertyOptional({
    description: 'Initial balance',
    example: 10000.0,
    default: 0,
  })
  @IsNumber()
  @IsOptional()
  balance?: number;

  @ApiPropertyOptional({
    description: 'Account currency',
    example: 'USD',
    default: 'USD',
  })
  @IsString()
  @IsOptional()
  currency?: string;

  @ApiPropertyOptional({
    description: 'Bank or Institution name',
    example: 'HDFC Bank',
  })
  @IsString()
  @IsOptional()
  bankName?: string;

  @ApiPropertyOptional({
    description: 'Account number (last 4 digits or masked)',
    example: '****1234',
  })
  @IsString()
  @IsOptional()
  accountNumber?: string;

  @ApiPropertyOptional({
    description: 'Bank routing number or IFSC code',
    example: 'HDFC0001234',
  })
  @IsString()
  @IsOptional()
  routingNumber?: string;

  @ApiPropertyOptional({
    description: 'Is this the default account',
    default: false,
  })
  @IsBoolean()
  @IsOptional()
  isDefault?: boolean;

  @ApiPropertyOptional({
    description: 'Hex color string for UI representation',
    example: '0xFF6C63FF',
  })
  @IsString()
  @IsOptional()
  color?: string;

  @ApiPropertyOptional({
    description: 'Icon asset or name',
    example: 'bank_icon',
  })
  @IsString()
  @IsOptional()
  icon?: string;
}
