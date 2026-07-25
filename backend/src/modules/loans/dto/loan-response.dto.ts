import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { LoanType } from './create-loan.dto';

export class LoanPaymentResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  loanId!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440002' })
  accountId!: string;

  @ApiProperty({ example: 4500.0 })
  amount!: number;

  @ApiPropertyOptional({ example: 3500.0 })
  principalAmount?: number | null;

  @ApiPropertyOptional({ example: 1000.0 })
  interestAmount?: number | null;

  @ApiPropertyOptional({ example: 'July EMI' })
  note?: string | null;

  @ApiPropertyOptional()
  dueDate?: Date | null;

  @ApiPropertyOptional()
  paidDate?: Date | null;

  @ApiProperty({ example: true })
  isPaid!: boolean;

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}

export class LoanResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  userId!: string;

  @ApiProperty({ example: 'Home Loan - HDFC' })
  name!: string;

  @ApiProperty({ enum: LoanType, example: LoanType.HOME_LOAN })
  type!: string;

  @ApiPropertyOptional({ example: 'HDFC Bank' })
  lender?: string | null;

  @ApiProperty({ example: 500000.0 })
  principal!: number;

  @ApiProperty({ example: 450000.0 })
  currentAmount!: number;

  @ApiProperty({ example: 8.5 })
  interestRate!: number;

  @ApiPropertyOptional({ example: 4500.0 })
  emiAmount?: number | null;

  @ApiProperty()
  startDate!: Date;

  @ApiPropertyOptional()
  endDate?: Date | null;

  @ApiProperty({ example: true })
  isActive!: boolean;

  @ApiProperty({ type: [LoanPaymentResponseDto] })
  payments!: LoanPaymentResponseDto[];

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
