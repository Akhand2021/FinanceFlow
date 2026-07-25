import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AuthTokensDto } from './auth-tokens.dto';

export class AuthResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: 'user@example.com' })
  email!: string;

  @ApiProperty({ example: 'John' })
  firstName!: string;

  @ApiProperty({ example: 'Doe' })
  lastName!: string;

  @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg' })
  profilePicture?: string;

  @ApiProperty({ type: AuthTokensDto })
  tokens!: AuthTokensDto;
}
