import { IsString, IsEnum, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum SmsReviewAction {
  ACCEPT = 'ACCEPT',
  REJECT = 'REJECT',
  IGNORE = 'IGNORE',
}

export class ProcessSmsDto {
  @ApiProperty({ enum: SmsReviewAction, example: SmsReviewAction.ACCEPT })
  @IsEnum(SmsReviewAction)
  action!: SmsReviewAction;

  @ApiPropertyOptional({
    description: 'Account ID to assign transaction to on ACCEPT',
    example: '550e8400-e29b-41d4-a716-446655440001',
  })
  @IsString()
  @IsOptional()
  accountId?: string;

  @ApiPropertyOptional({
    description: 'Category ID to assign transaction to on ACCEPT',
    example: '550e8400-e29b-41d4-a716-446655440002',
  })
  @IsString()
  @IsOptional()
  categoryId?: string;
}
