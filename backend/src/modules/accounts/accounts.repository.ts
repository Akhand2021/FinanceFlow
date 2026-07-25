import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { AccountEntity } from './entities/account.entity';
import { CreateAccountDto } from './dto/create-account.dto';
import { UpdateAccountDto } from './dto/update-account.dto';

@Injectable()
export class AccountsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllByUserId(userId: string): Promise<AccountEntity[]> {
    const accounts = await this.prisma.account.findMany({
      where: { userId, deletedAt: null },
      orderBy: { createdAt: 'asc' },
    });
    return accounts.map((account) => this.mapToEntity(account));
  }

  async findById(id: string, userId: string): Promise<AccountEntity | null> {
    const account = await this.prisma.account.findFirst({
      where: { id, userId, deletedAt: null },
    });
    return account ? this.mapToEntity(account) : null;
  }

  async create(userId: string, dto: CreateAccountDto): Promise<AccountEntity> {
    // If this is set as default, unset other defaults first
    if (dto.isDefault) {
      await this.prisma.account.updateMany({
        where: { userId, isDefault: true },
        data: { isDefault: false },
      });
    }

    const account = await this.prisma.account.create({
      data: {
        userId,
        name: dto.name,
        type: dto.type,
        balance: dto.balance ?? 0,
        currency: dto.currency ?? 'USD',
        bankName: dto.bankName,
        accountNumber: dto.accountNumber,
        routingNumber: dto.routingNumber,
        isDefault: dto.isDefault ?? false,
        color: dto.color ?? '0xFF6C63FF',
        icon: dto.icon,
      },
    });

    return this.mapToEntity(account);
  }

  async update(
    id: string,
    userId: string,
    dto: UpdateAccountDto,
  ): Promise<AccountEntity> {
    if (dto.isDefault) {
      await this.prisma.account.updateMany({
        where: { userId, isDefault: true, NOT: { id } },
        data: { isDefault: false },
      });
    }

    const account = await this.prisma.account.update({
      where: { id },
      data: {
        ...dto,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(account);
  }

  async updateBalance(id: string, amountChange: number): Promise<AccountEntity> {
    const account = await this.prisma.account.update({
      where: { id },
      data: {
        balance: {
          increment: amountChange,
        },
        updatedAt: new Date(),
      },
    });
    return this.mapToEntity(account);
  }

  async softDelete(id: string, userId: string): Promise<void> {
    await this.prisma.account.updateMany({
      where: { id, userId },
      data: { deletedAt: new Date() },
    });
  }

  private mapToEntity(account: any): AccountEntity {
    return new AccountEntity({
      id: account.id,
      userId: account.userId,
      name: account.name,
      type: account.type,
      balance: Number(account.balance),
      currency: account.currency,
      bankName: account.bankName,
      accountNumber: account.accountNumber,
      routingNumber: account.routingNumber,
      isDefault: account.isDefault,
      color: account.color,
      icon: account.icon,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
      deletedAt: account.deletedAt,
    });
  }
}
