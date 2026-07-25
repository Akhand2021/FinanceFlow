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

export enum LoanType {
  HOME_LOAN = 'HOME_LOAN',
  CAR_LOAN = 'CAR_LOAN',
  PERSONAL_LOAN = 'PERSONAL_LOAN',
  CREDIT_CARD = 'CREDIT_CARD',
  BORROWED = 'BORROWED',
  LENT = 'LENT',
}

export class CreateLoanDto {
  @ApiProperty({ example: 'Home Loan - HDFC Bank' })
  @IsString()
  @IsNotEmpty()
  name!: string;

  @ApiProperty({ enum: LoanType, example: LoanType.HOME_LOAN })
  @IsEnum(LoanType)
  type!: LoanType;

  @ApiPropertyOptional({ example: 'HDFC Bank' })
  @IsString()
  @IsOptional()
  lender?: string;

  @ApiProperty({ example: 500000.0 })
  @IsNumber()
  @Min(0.01)
  principal!: number;

  @ApiPropertyOptional({ example: 450000.0 })
  @IsNumber()
  @Min(0)
  @IsOptional()
  currentAmount?: number;

  @ApiProperty({ example: 8.5, description: 'Annual interest rate percentage' })
  @IsNumber()
  @Min(0)
  interestRate!: number;

  @ApiPropertyOptional({ example: 4500.0, description: 'Monthly EMI amount' })
  @IsNumber()
  @Min(0)
  @IsOptional()
  emiAmount?: number;

  @ApiProperty({ example: '2025-01-01T00:00:00.000Z' })
  @IsDateString()
  startDate!: string;

  @ApiPropertyOptional({ example: '2045-01-01T00:00:00.000Z' })
  @IsDateString()
  @IsOptional()
  endDate?: string;
}
