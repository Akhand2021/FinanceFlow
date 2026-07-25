import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { UserEntity } from '@auth/entities/user.entity';

@Injectable()
export class UserRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findById(id: string): Promise<UserEntity | null> {
    const user = await this.prisma.user.findUnique({
      where: { id },
    });

    if (!user || user.deletedAt) {
      return null;
    }

    return this.mapToEntity(user);
  }

  async findByEmail(email: string): Promise<UserEntity | null> {
    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user || user.deletedAt) {
      return null;
    }

    return this.mapToEntity(user);
  }

  async findRawByEmail(email: string): Promise<any | null> {
    const user = await this.prisma.user.findUnique({
      where: { email },
    });

    if (!user || user.deletedAt) {
      return null;
    }

    return user;
  }

  async create(data: {
    email: string;
    firstName: string;
    lastName: string;
    passwordHash: string;
  }): Promise<UserEntity> {
    const user = await this.prisma.user.create({
      data: {
        email: data.email,
        firstName: data.firstName,
        lastName: data.lastName,
        passwordHash: data.passwordHash,
        currency: 'USD',
        language: 'en',
        theme: 'light',
      },
    });

    return this.mapToEntity(user);
  }

  async update(
    id: string,
    data: Partial<{
      firstName: string;
      lastName: string;
      profilePicture: string;
      currency: string;
      language: string;
      theme: string;
    }>,
  ): Promise<UserEntity> {
    const user = await this.prisma.user.update({
      where: { id },
      data,
    });

    return this.mapToEntity(user);
  }

  async updateLastLogin(id: string): Promise<void> {
    await this.prisma.user.update({
      where: { id },
      data: { updatedAt: new Date() },
    });
  }

  async softDelete(id: string): Promise<void> {
    await this.prisma.user.update({
      where: { id },
      data: { deletedAt: new Date() },
    });
  }

  async updatePassword(id: string, passwordHash: string): Promise<void> {
    await this.prisma.user.update({
      where: { id },
      data: { passwordHash, updatedAt: new Date() },
    });
  }

  async createRefreshToken(
    userId: string,
    token: string,
    expiresAt: Date,
  ): Promise<void> {
    await this.prisma.refreshToken.create({
      data: {
        userId,
        token,
        expiresAt,
      },
    });
  }

  async findRefreshToken(token: string): Promise<any> {
    return this.prisma.refreshToken.findUnique({
      where: { token },
    });
  }

  async revokeRefreshToken(token: string): Promise<void> {
    await this.prisma.refreshToken.update({
      where: { token },
      data: { revokedAt: new Date() },
    });
  }

  async revokeAllUserRefreshTokens(userId: string): Promise<void> {
    await this.prisma.refreshToken.updateMany({
      where: {
        userId,
        revokedAt: null,
      },
      data: { revokedAt: new Date() },
    });
  }

  async createAuditLog(data: {
    userId: string;
    action: string;
    entity: string;
    entityId?: string;
    changes?: any;
  }): Promise<void> {
    try {
      await this.prisma.auditLog.create({
        data: {
          userId: data.userId,
          action: data.action,
          entity: data.entity,
          entityId: data.entityId,
          changes: data.changes,
        },
      });
    } catch (error) {
      console.error('Failed to create audit log:', error);
    }
  }

  mapToEntity(user: any): UserEntity {
    return new UserEntity({
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
      deletedAt: user.deletedAt,
    });
  }
}
