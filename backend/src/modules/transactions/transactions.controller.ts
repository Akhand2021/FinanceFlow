import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
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
import { TransactionsService } from './transactions.service';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { UpdateTransactionDto } from './dto/update-transaction.dto';
import { QueryTransactionDto } from './dto/query-transaction.dto';
import { TransactionResponseDto } from './dto/transaction-response.dto';

@ApiTags('Transactions')
@Controller('transactions')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class TransactionsController {
  constructor(private readonly transactionsService: TransactionsService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Query paginated transactions',
    description: 'Filter, search, and paginate transactions across Income, Expense, Transfer',
  })
  @ApiResponse({
    status: 200,
    description: 'Paginated transactions list retrieved successfully',
  })
  async getTransactions(
    @CurrentUser() user: any,
    @Query() query: QueryTransactionDto,
  ): Promise<{ data: TransactionResponseDto[]; total: number; page: number; limit: number }> {
    return this.transactionsService.getTransactions(user.sub, query);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get transaction by ID' })
  @ApiResponse({
    status: 200,
    description: 'Transaction details retrieved',
    type: TransactionResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Transaction not found' })
  async getTransactionById(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<TransactionResponseDto> {
    return this.transactionsService.getTransactionById(id, user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create transaction (INCOME, EXPENSE, TRANSFER)' })
  @ApiResponse({
    status: 201,
    description: 'Transaction created and account balances updated atomically',
    type: TransactionResponseDto,
  })
  async createTransaction(
    @CurrentUser() user: any,
    @Body() dto: CreateTransactionDto,
  ): Promise<TransactionResponseDto> {
    return this.transactionsService.createTransaction(user.sub, dto);
  }

  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update a transaction' })
  @ApiResponse({
    status: 200,
    description: 'Transaction updated and balances recalculated',
    type: TransactionResponseDto,
  })
  async updateTransaction(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: UpdateTransactionDto,
  ): Promise<TransactionResponseDto> {
    return this.transactionsService.updateTransaction(id, user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft delete a transaction and reverse balance' })
  @ApiResponse({ status: 200, description: 'Transaction deleted successfully' })
  async deleteTransaction(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<{ message: string }> {
    await this.transactionsService.deleteTransaction(id, user.sub);
    return { message: 'Transaction deleted successfully' };
  }
}
