import { Injectable } from '@nestjs/common';
import { AccountsRepository } from './accounts.repository';
import { CreateAccountDto } from './dto/create-account.dto';
import { UpdateAccountDto } from './dto/update-account.dto';
import { AccountEntity } from './entities/account.entity';
import { NotFoundException } from '@common/exceptions/api.exception';

@Injectable()
export class AccountsService {
  constructor(private readonly accountsRepository: AccountsRepository) {}

  async getUserAccounts(userId: string): Promise<AccountEntity[]> {
    return this.accountsRepository.findAllByUserId(userId);
  }

  async getAccountById(id: string, userId: string): Promise<AccountEntity> {
    const account = await this.accountsRepository.findById(id, userId);
    if (!account) {
      throw new NotFoundException('Account');
    }
    return account;
  }

  async createAccount(
    userId: string,
    dto: CreateAccountDto,
  ): Promise<AccountEntity> {
    return this.accountsRepository.create(userId, dto);
  }

  async updateAccount(
    id: string,
    userId: string,
    dto: UpdateAccountDto,
  ): Promise<AccountEntity> {
    await this.getAccountById(id, userId);
    return this.accountsRepository.update(id, userId, dto);
  }

  async deleteAccount(id: string, userId: string): Promise<void> {
    await this.getAccountById(id, userId);
    await this.accountsRepository.softDelete(id, userId);
  }
}
