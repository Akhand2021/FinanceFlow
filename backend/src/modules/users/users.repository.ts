import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { UserSettingsEntity } from './entities/user-settings.entity';
import { UpdateUserSettingsDto } from './dto/update-user-settings.dto';

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<UserSettingsEntity | null> {
    const user = await this.prisma.user.findUnique({
      where: { id },
    });
    return user && !user.deletedAt ? this.mapToEntity(user) : null;
  }

  async updateSettings(
    id: string,
    dto: UpdateUserSettingsDto,
  ): Promise<UserSettingsEntity> {
    const user = await this.prisma.user.update({
      where: { id },
      data: {
        firstName: dto.firstName,
        lastName: dto.lastName,
        phone: dto.phone,
        currency: dto.currency,
        language: dto.language,
        theme: dto.theme,
        pinnedLocked: dto.pinnedLocked,
        biometricLocked: dto.biometricLocked,
        updatedAt: new Date(),
      },
    });

    return this.mapToEntity(user);
  }

  async exportUserData(userId: string): Promise<any> {
    const user = await this.findById(userId);
    const accounts = await this.prisma.account.findMany({ where: { userId, deletedAt: null } });
    const categories = await this.prisma.category.findMany({ where: { userId, deletedAt: null } });
    const transactions = await this.prisma.transaction.findMany({ where: { userId, deletedAt: null } });
    const budgets = await this.prisma.budget.findMany({ where: { userId, deletedAt: null }, include: { items: true } });
    const savingGoals = await this.prisma.savingGoal.findMany({ where: { userId, deletedAt: null }, include: { contributions: true } });
    const loans = await this.prisma.loan.findMany({ where: { userId, deletedAt: null }, include: { payments: true } });

    return {
      exportedAt: new Date(),
      profile: user,
      accounts,
      categories,
      transactions,
      budgets,
      savingGoals,
      loans,
    };
  }

  async deleteAccount(userId: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      // 1. Soft delete user
      await tx.user.update({
        where: { id: userId },
        data: { deletedAt: new Date() },
      });

      // 2. Revoke all refresh tokens
      await tx.refreshToken.updateMany({
        where: { userId, revokedAt: null },
        data: { revokedAt: new Date() },
      });

      // 3. Create audit log
      await tx.auditLog.create({
        data: {
          userId,
          action: 'DELETE_ACCOUNT',
          entity: 'User',
          entityId: userId,
        },
      });
    });
  }

  private mapToEntity(user: any): UserSettingsEntity {
    return new UserSettingsEntity({
      id: user.id,
      email: user.email,
      phone: user.phone,
      firstName: user.firstName,
      lastName: user.lastName,
      profilePicture: user.profilePicture,
      currency: user.currency,
      language: user.language,
      theme: user.theme,
      pinnedLocked: user.pinnedLocked,
      biometricLocked: user.biometricLocked,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    });
  }
}
