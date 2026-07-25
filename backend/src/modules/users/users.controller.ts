import {
  Controller,
  Get,
  Put,
  Delete,
  Body,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtGuard } from '@common/guards/jwt.guard';
import { CurrentUser } from '@common/decorators/current-user.decorator';
import { UsersService } from './users.service';
import { UpdateUserSettingsDto } from './dto/update-user-settings.dto';
import { UserSettingsResponseDto } from './dto/user-settings-response.dto';

@ApiTags('Settings & User Profile')
@Controller('users')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('settings')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get user settings & preferences' })
  @ApiResponse({
    status: 200,
    type: UserSettingsResponseDto,
  })
  async getSettings(@CurrentUser() user: any): Promise<UserSettingsResponseDto> {
    return this.usersService.getUserSettings(user.sub);
  }

  @Put('settings')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update theme, currency, language, PIN, or biometric lock' })
  @ApiResponse({
    status: 200,
    type: UserSettingsResponseDto,
  })
  async updateSettings(
    @CurrentUser() user: any,
    @Body() dto: UpdateUserSettingsDto,
  ): Promise<UserSettingsResponseDto> {
    return this.usersService.updateUserSettings(user.sub, dto);
  }

  @Get('export')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Export complete user data backup (JSON format)' })
  @ApiResponse({
    status: 200,
    description: 'Full data backup JSON object returned',
  })
  async exportData(@CurrentUser() user: any): Promise<any> {
    return this.usersService.exportUserData(user.sub);
  }

  @Delete('account')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete user account (Soft delete & revoke all tokens)' })
  @ApiResponse({ status: 200, description: 'Account deleted successfully' })
  async deleteAccount(@CurrentUser() user: any): Promise<{ message: string }> {
    await this.usersService.deleteAccount(user.sub);
    return { message: 'Account deleted successfully' };
  }
}
