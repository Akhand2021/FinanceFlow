import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { UsersRepository } from './users.repository';
import { UserSettingsEntity } from './entities/user-settings.entity';
import { NotFoundException } from '@common/exceptions/api.exception';

describe('UsersService', () => {
  let service: UsersService;
  let repository: UsersRepository;

  const mockUser = new UserSettingsEntity({
    id: 'user-123',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    currency: 'USD',
    language: 'en',
    theme: 'light',
    pinnedLocked: false,
    biometricLocked: false,
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: UsersRepository,
          useValue: {
            findById: jest.fn(),
            updateSettings: jest.fn(),
            exportUserData: jest.fn(),
            deleteAccount: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    repository = module.get<UsersRepository>(UsersRepository);
  });

  it('should return user settings', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(mockUser);
    const result = await service.getUserSettings('user-123');
    expect(result.email).toBe('test@example.com');
  });

  it('should throw NotFoundException if user profile not found', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(service.getUserSettings('invalid-user')).rejects.toThrow(
      NotFoundException,
    );
  });

  it('should update settings (theme, currency, pin/biometric)', async () => {
    const updatedUser = new UserSettingsEntity({ ...mockUser, theme: 'dark', biometricLocked: true });
    jest.spyOn(repository, 'findById').mockResolvedValue(mockUser);
    jest.spyOn(repository, 'updateSettings').mockResolvedValue(updatedUser);

    const result = await service.updateUserSettings('user-123', {
      theme: 'dark',
      biometricLocked: true,
    });

    expect(result.theme).toBe('dark');
    expect(result.biometricLocked).toBe(true);
  });

  it('should export user data backup', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(mockUser);
    jest.spyOn(repository, 'exportUserData').mockResolvedValue({ profile: mockUser, accounts: [] });

    const result = await service.exportUserData('user-123');
    expect(result.profile).toBeDefined();
  });
});
