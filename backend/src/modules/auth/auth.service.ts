import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UtilsService } from '@common/utils/utils.service';
import { ConflictException, UnauthorizedException, NotFoundException } from '@common/exceptions/api.exception';
import { UserEntity } from '@auth/entities/user.entity';
import { UserRepository } from '@auth/auth.repository';
import { RegisterDto } from '@auth/dto/register.dto';
import { LoginDto } from '@auth/dto/login.dto';
import { AuthTokensDto } from '@auth/dto/auth-tokens.dto';
import { ForgotPasswordDto } from '@auth/dto/forgot-password.dto';
import { ResetPasswordDto } from '@auth/dto/reset-password.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly jwtService: JwtService,
    private readonly utilsService: UtilsService,
  ) {}

  /**
   * Register a new user
   */
  async register(registerDto: RegisterDto): Promise<{
    user: UserEntity;
    tokens: AuthTokensDto;
  }> {
    // Validate passwords match
    if (registerDto.password !== registerDto.confirmPassword) {
      throw new ConflictException('Passwords do not match');
    }

    // Check if user exists
    const existingUser = await this.userRepository.findByEmail(registerDto.email);
    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    // Hash password
    const passwordHash = await this.utilsService.hashPassword(registerDto.password);

    // Create user
    const user = await this.userRepository.create({
      email: registerDto.email,
      firstName: registerDto.firstName,
      lastName: registerDto.lastName,
      passwordHash,
    });

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.email);

    // Create refresh token record
    await this.createRefreshTokenRecord(user.id, tokens.refreshToken);

    // Log audit
    await this.userRepository.createAuditLog({
      userId: user.id,
      action: 'CREATE',
      entity: 'User',
      entityId: user.id,
    });

    return {
      user,
      tokens,
    };
  }

  /**
   * Login user
   */
  async login(loginDto: LoginDto): Promise<{
    user: UserEntity;
    tokens: AuthTokensDto;
  }> {
    // Find raw user record containing passwordHash
    const rawUser = await this.userRepository.findRawByEmail(loginDto.email);
    if (!rawUser || rawUser.deletedAt) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await this.utilsService.comparePassword(
      loginDto.password,
      rawUser.passwordHash,
    );

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const user = this.userRepository.mapToEntity(rawUser);

    // Generate tokens
    const tokens = await this.generateTokens(user.id, user.email);

    // Create refresh token record
    await this.createRefreshTokenRecord(user.id, tokens.refreshToken);

    // Update last login
    await this.userRepository.updateLastLogin(user.id);

    // Log audit
    await this.userRepository.createAuditLog({
      userId: user.id,
      action: 'READ',
      entity: 'User',
      entityId: user.id,
    });

    return {
      user,
      tokens,
    };
  }

  /**
   * Refresh access token
   */
  async refreshToken(refreshToken: string): Promise<AuthTokensDto> {
    try {
      // Verify refresh token
      const payload = await this.jwtService.verifyAsync(refreshToken, {
        secret: process.env.JWT_SECRET,
      });

      // Check if token is revoked
      const storedToken = await this.userRepository.findRefreshToken(refreshToken);

      if (!storedToken || storedToken.revokedAt || storedToken.expiresAt < new Date()) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      // Generate new tokens
      const newTokens = await this.generateTokens(payload.sub, payload.email);

      // Revoke old token and create new one
      await this.userRepository.revokeRefreshToken(refreshToken);
      await this.createRefreshTokenRecord(payload.sub, newTokens.refreshToken);

      return newTokens;
    } catch (error) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  /**
   * Logout user (revoke specific or all refresh tokens)
   */
  async logout(userId: string, refreshToken?: string): Promise<void> {
    if (refreshToken) {
      await this.userRepository.revokeRefreshToken(refreshToken);
    } else {
      await this.userRepository.revokeAllUserRefreshTokens(userId);
    }

    await this.userRepository.createAuditLog({
      userId,
      action: 'DELETE',
      entity: 'RefreshToken',
      entityId: userId,
    });
  }

  /**
   * Request password reset token / email
   */
  async forgotPassword(forgotPasswordDto: ForgotPasswordDto): Promise<{ message: string }> {
    const user = await this.userRepository.findByEmail(forgotPasswordDto.email);
    if (!user) {
      return { message: 'If an account exists with this email, password reset instructions have been sent.' };
    }

    await this.userRepository.createAuditLog({
      userId: user.id,
      action: 'FORGOT_PASSWORD_REQUEST',
      entity: 'User',
      entityId: user.id,
      changes: { resetTokenSent: true },
    });

    return {
      message: 'If an account exists with this email, password reset instructions have been sent.',
    };
  }

  /**
   * Reset password with token
   */
  async resetPassword(resetPasswordDto: ResetPasswordDto): Promise<{ message: string }> {
    if (resetPasswordDto.newPassword !== resetPasswordDto.confirmPassword) {
      throw new ConflictException('Passwords do not match');
    }

    let payload: any;
    try {
      payload = await this.jwtService.verifyAsync(resetPasswordDto.token, {
        secret: process.env.JWT_SECRET,
      });
      if (payload.type !== 'PASSWORD_RESET') {
        throw new UnauthorizedException('Invalid reset token');
      }
    } catch (err) {
      throw new UnauthorizedException('Invalid or expired reset token');
    }

    const newPasswordHash = await this.utilsService.hashPassword(resetPasswordDto.newPassword);
    await this.userRepository.updatePassword(payload.sub, newPasswordHash);

    // Revoke all active sessions on password reset for security
    await this.userRepository.revokeAllUserRefreshTokens(payload.sub);

    await this.userRepository.createAuditLog({
      userId: payload.sub,
      action: 'PASSWORD_RESET_SUCCESS',
      entity: 'User',
      entityId: payload.sub,
    });

    return { message: 'Password has been reset successfully.' };
  }

  /**
   * Get user by ID
   */
  async getUserById(id: string): Promise<UserEntity> {
    const user = await this.userRepository.findById(id);

    if (!user || user.deletedAt) {
      throw new NotFoundException('User');
    }

    return user;
  }

  /**
   * Verify JWT token
   */
  async verifyToken(token: string): Promise<any> {
    try {
      return await this.jwtService.verifyAsync(token, {
        secret: process.env.JWT_SECRET,
      });
    } catch (error) {
      throw new UnauthorizedException('Invalid token');
    }
  }

  /**
   * Generate access and refresh tokens
   */
  private async generateTokens(
    userId: string,
    email: string,
  ): Promise<AuthTokensDto> {
    const accessToken = await this.jwtService.signAsync(
      { sub: userId, email },
      {
        secret: process.env.JWT_SECRET,
        expiresIn: process.env.JWT_EXPIRATION || '24h',
      },
    );

    const refreshToken = await this.jwtService.signAsync(
      { sub: userId, email },
      {
        secret: process.env.JWT_REFRESH_SECRET,
        expiresIn: process.env.JWT_REFRESH_EXPIRATION || '7d',
      },
    );

    return {
      accessToken,
      refreshToken,
      expiresIn: 86400, // 24 hours in seconds
      tokenType: 'Bearer',
    };
  }

  /**
   * Create refresh token record
   */
  private async createRefreshTokenRecord(
    userId: string,
    token: string,
  ): Promise<void> {
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7); // 7 days

    await this.userRepository.createRefreshToken(userId, token, expiresAt);
  }
}
