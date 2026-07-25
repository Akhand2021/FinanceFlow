import { IsNumber, IsOptional, IsString, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AddContributionDto {
  @ApiProperty({ example: 500.0 })
  @IsNumber()
  @Min(0.01)
  amount!: number;

  @ApiPropertyOptional({ example: 'July savings contribution' })
  @IsString()
  @IsOptional()
  note?: string;
}
