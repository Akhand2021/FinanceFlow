import { Injectable } from '@nestjs/common';
import { UsersRepository } from './users.repository';
import { UpdateUserSettingsDto } from './dto/update-user-settings.dto';
import { UserSettingsEntity } from './entities/user-settings.entity';
import { NotFoundException } from '@common/exceptions/api.exception';

@Injectable()
export class UsersService {
  constructor(private readonly usersRepository: UsersRepository) {}

  async getUserSettings(userId: string): Promise<UserSettingsEntity> {
    const user = await this.usersRepository.findById(userId);
    if (!user) {
      throw new NotFoundException('User profile');
    }
    return user;
  }

  async updateUserSettings(
    userId: string,
    dto: UpdateUserSettingsDto,
  ): Promise<UserSettingsEntity> {
    await this.getUserSettings(userId);
    return this.usersRepository.updateSettings(userId, dto);
  }

  async exportUserData(userId: string): Promise<any> {
    await this.getUserSettings(userId);
    return this.usersRepository.exportUserData(userId);
  }

  async deleteAccount(userId: string): Promise<void> {
    await this.getUserSettings(userId);
    await this.usersRepository.deleteAccount(userId);
  }
}
