import { IsString, IsNotEmpty, IsNumber, IsOptional, Min, Max } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateMerchantRuleDto {
  @ApiProperty({ example: 'Swiggy' })
  @IsString()
  @IsNotEmpty()
  merchantName!: string;

  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440001' })
  @IsString()
  @IsNotEmpty()
  categoryId!: string;

  @ApiPropertyOptional({ example: 0.9, default: 0.8 })
  @IsNumber()
  @Min(0)
  @Max(1)
  @IsOptional()
  confidence?: number;
}
