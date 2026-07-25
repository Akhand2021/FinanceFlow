import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class UserSettingsResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id!: string;

  @ApiProperty({ example: 'user@example.com' })
  email!: string;

  @ApiPropertyOptional({ example: '+1234567890' })
  phone?: string | null;

  @ApiProperty({ example: 'John' })
  firstName!: string;

  @ApiProperty({ example: 'Doe' })
  lastName!: string;

  @ApiPropertyOptional({ example: 'https://example.com/avatar.jpg' })
  profilePicture?: string | null;

  @ApiProperty({ example: 'USD' })
  currency!: string;

  @ApiProperty({ example: 'en' })
  language!: string;

  @ApiProperty({ example: 'dark' })
  theme!: string;

  @ApiProperty({ example: false })
  pinnedLocked!: boolean;

  @ApiProperty({ example: false })
  biometricLocked!: boolean;

  @ApiProperty()
  createdAt!: Date;

  @ApiProperty()
  updatedAt!: Date;
}
