import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { AuthService } from '@modules/auth/auth.service';
import { UserRepository } from '@modules/auth/auth.repository';
import { UtilsService } from '@common/utils/utils.service';
import { RegisterDto } from '@modules/auth/dto/register.dto';
import { LoginDto } from '@modules/auth/dto/login.dto';
import { UserEntity } from '@modules/auth/entities/user.entity';
import { ConflictException, UnauthorizedException } from '@common/exceptions/api.exception';

describe('AuthService', () => {
  let service: AuthService;
  let userRepository: UserRepository;
  let jwtService: JwtService;
  let utilsService: UtilsService;

  const mockUserEntity = new UserEntity({
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    profilePicture: null,
    currency: 'USD',
    language: 'en',
    theme: 'light',
    pinnedLocked: false,
    biometricLocked: false,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
  });

  const mockRawUser = {
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'test@example.com',
    passwordHash: 'hashedPassword123',
    firstName: 'John',
    lastName: 'Doe',
    profilePicture: null,
    currency: 'USD',
    language: 'en',
    theme: 'light',
    pinnedLocked: false,
    biometricLocked: false,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UserRepository,
          useValue: {
            findById: jest.fn(),
            findByEmail: jest.fn(),
            findRawByEmail: jest.fn(),
            mapToEntity: jest.fn().mockReturnValue(mockUserEntity),
            create: jest.fn(),
            update: jest.fn(),
            updatePassword: jest.fn(),
            updateLastLogin: jest.fn(),
            softDelete: jest.fn(),
            createRefreshToken: jest.fn(),
            findRefreshToken: jest.fn(),
            revokeRefreshToken: jest.fn(),
            revokeAllUserRefreshTokens: jest.fn(),
            createAuditLog: jest.fn(),
          },
        },
        {
          provide: JwtService,
          useValue: {
            signAsync: jest.fn(),
            verifyAsync: jest.fn(),
          },
        },
        {
          provide: UtilsService,
          useValue: {
            hashPassword: jest.fn(),
            comparePassword: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    userRepository = module.get<UserRepository>(UserRepository);
    jwtService = module.get<JwtService>(JwtService);
    utilsService = module.get<UtilsService>(UtilsService);
  });

  describe('register', () => {
    it('should register a new user successfully', async () => {
      const registerDto: RegisterDto = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'SecurePass123',
        confirmPassword: 'SecurePass123',
      };

      jest.spyOn(userRepository, 'findByEmail').mockResolvedValue(null);
      jest.spyOn(utilsService, 'hashPassword').mockResolvedValue('hashedPassword123');
      jest.spyOn(userRepository, 'create').mockResolvedValue(mockUserEntity);
      jest.spyOn(jwtService, 'signAsync').mockResolvedValue('token123');
      jest.spyOn(userRepository, 'createRefreshToken').mockResolvedValue(undefined);
      jest.spyOn(userRepository, 'createAuditLog').mockResolvedValue(undefined);

      const result = await service.register(registerDto);

      expect(result.user.email).toBe('test@example.com');
      expect(result.tokens).toBeDefined();
      expect(result.tokens.accessToken).toBe('token123');
      expect(userRepository.create).toHaveBeenCalled();
    });

    it('should throw error when passwords do not match', async () => {
      const registerDto: RegisterDto = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'SecurePass123',
        confirmPassword: 'DifferentPass123',
      };

      await expect(service.register(registerDto)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should throw error when email already exists', async () => {
      const registerDto: RegisterDto = {
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        password: 'SecurePass123',
        confirmPassword: 'SecurePass123',
      };

      jest.spyOn(userRepository, 'findByEmail').mockResolvedValue(mockUserEntity);

      await expect(service.register(registerDto)).rejects.toThrow(
        ConflictException,
      );
    });
  });

  describe('login', () => {
    it('should login user successfully', async () => {
      const loginDto: LoginDto = {
        email: 'test@example.com',
        password: 'SecurePass123',
      };

      jest.spyOn(userRepository, 'findRawByEmail').mockResolvedValue(mockRawUser);
      jest.spyOn(utilsService, 'comparePassword').mockResolvedValue(true);
      jest.spyOn(jwtService, 'signAsync').mockResolvedValue('token123');
      jest.spyOn(userRepository, 'createRefreshToken').mockResolvedValue(undefined);
      jest.spyOn(userRepository, 'updateLastLogin').mockResolvedValue(undefined);
      jest.spyOn(userRepository, 'createAuditLog').mockResolvedValue(undefined);

      const result = await service.login(loginDto);

      expect(result.user.email).toBe('test@example.com');
      expect(result.tokens).toBeDefined();
    });

    it('should throw error with invalid credentials', async () => {
      const loginDto: LoginDto = {
        email: 'test@example.com',
        password: 'WrongPassword',
      };

      jest.spyOn(userRepository, 'findRawByEmail').mockResolvedValue(null);

      await expect(service.login(loginDto)).rejects.toThrow(
        UnauthorizedException,
      );
    });

    it('should throw error with wrong password', async () => {
      const loginDto: LoginDto = {
        email: 'test@example.com',
        password: 'WrongPassword',
      };

      jest.spyOn(userRepository, 'findRawByEmail').mockResolvedValue(mockRawUser);
      jest.spyOn(utilsService, 'comparePassword').mockResolvedValue(false);

      await expect(service.login(loginDto)).rejects.toThrow(
        UnauthorizedException,
      );
    });
  });

  describe('refreshToken', () => {
    it('should refresh token successfully', async () => {
      const oldRefreshToken = 'oldToken123';

      jest.spyOn(jwtService, 'verifyAsync').mockResolvedValue({
        sub: mockUserEntity.id,
        email: mockUserEntity.email,
      });
      jest.spyOn(userRepository, 'findRefreshToken').mockResolvedValue({
        userId: mockUserEntity.id,
        token: oldRefreshToken,
        expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
        revokedAt: null,
      });
      jest.spyOn(jwtService, 'signAsync').mockResolvedValue('newToken123');
      jest.spyOn(userRepository, 'revokeRefreshToken').mockResolvedValue(undefined);
      jest.spyOn(userRepository, 'createRefreshToken').mockResolvedValue(undefined);

      const result = await service.refreshToken(oldRefreshToken);

      expect(result.accessToken).toBe('newToken123');
      expect(result.refreshToken).toBe('newToken123');
    });

    it('should throw error with invalid refresh token', async () => {
      jest.spyOn(jwtService, 'verifyAsync').mockRejectedValue(new Error('Invalid token'));

      await expect(service.refreshToken('invalidToken')).rejects.toThrow(
        UnauthorizedException,
      );
    });
  });
});
