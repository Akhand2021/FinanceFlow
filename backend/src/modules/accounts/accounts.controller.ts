import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
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
import { AccountsService } from './accounts.service';
import { CreateAccountDto } from './dto/create-account.dto';
import { UpdateAccountDto } from './dto/update-account.dto';
import { AccountResponseDto } from './dto/account-response.dto';

@ApiTags('Accounts')
@Controller('accounts')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class AccountsController {
  constructor(private readonly accountsService: AccountsService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all accounts for current user' })
  @ApiResponse({
    status: 200,
    description: 'Accounts list retrieved successfully',
    type: [AccountResponseDto],
  })
  async getAccounts(@CurrentUser() user: any): Promise<AccountResponseDto[]> {
    return this.accountsService.getUserAccounts(user.sub);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get account details by ID' })
  @ApiResponse({
    status: 200,
    description: 'Account details retrieved',
    type: AccountResponseDto,
  })
  @ApiResponse({ status: 44, description: 'Account not found' })
  async getAccountById(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<AccountResponseDto> {
    return this.accountsService.getAccountById(id, user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new account' })
  @ApiResponse({
    status: 201,
    description: 'Account created successfully',
    type: AccountResponseDto,
  })
  async createAccount(
    @CurrentUser() user: any,
    @Body() dto: CreateAccountDto,
  ): Promise<AccountResponseDto> {
    return this.accountsService.createAccount(user.sub, dto);
  }

  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update an account' })
  @ApiResponse({
    status: 200,
    description: 'Account updated successfully',
    type: AccountResponseDto,
  })
  async updateAccount(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: UpdateAccountDto,
  ): Promise<AccountResponseDto> {
    return this.accountsService.updateAccount(id, user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete an account (soft delete)' })
  @ApiResponse({ status: 200, description: 'Account deleted successfully' })
  async deleteAccount(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<{ message: string }> {
    await this.accountsService.deleteAccount(id, user.sub);
    return { message: 'Account deleted successfully' };
  }
}
