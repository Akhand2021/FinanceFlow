import { Injectable } from '@nestjs/common';
import { TransactionsRepository } from './transactions.repository';
import { CreateTransactionDto, TransactionType } from './dto/create-transaction.dto';
import { UpdateTransactionDto } from './dto/update-transaction.dto';
import { QueryTransactionDto } from './dto/query-transaction.dto';
import { TransactionEntity } from './entities/transaction.entity';
import { NotFoundException, BadRequestException } from '@common/exceptions/api.exception';

@Injectable()
export class TransactionsService {
  constructor(private readonly transactionsRepository: TransactionsRepository) {}

  async getTransactions(
    userId: string,
    query: QueryTransactionDto,
  ): Promise<{ data: TransactionEntity[]; total: number; page: number; limit: number }> {
    return this.transactionsRepository.findAll(userId, query);
  }

  async getTransactionById(id: string, userId: string): Promise<TransactionEntity> {
    const transaction = await this.transactionsRepository.findById(id, userId);
    if (!transaction) {
      throw new NotFoundException('Transaction');
    }
    return transaction;
  }

  async createTransaction(
    userId: string,
    dto: CreateTransactionDto,
  ): Promise<TransactionEntity> {
    if (dto.type === TransactionType.TRANSFER && !dto.toAccountId) {
      throw new BadRequestException('toAccountId is required for TRANSFER transaction type');
    }
    if (dto.type === TransactionType.TRANSFER && dto.accountId === dto.toAccountId) {
      throw new BadRequestException('Cannot transfer money to the same account');
    }

    return this.transactionsRepository.create(userId, dto);
  }

  async updateTransaction(
    id: string,
    userId: string,
    dto: UpdateTransactionDto,
  ): Promise<TransactionEntity> {
    await this.getTransactionById(id, userId);
    return this.transactionsRepository.update(id, userId, dto);
  }

  async deleteTransaction(id: string, userId: string): Promise<void> {
    await this.getTransactionById(id, userId);
    await this.transactionsRepository.softDelete(id, userId);
  }
}
