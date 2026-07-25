import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { AuthService } from '@auth/auth.service';
import { AuthController } from '@auth/auth.controller';
import { UserRepository } from '@auth/auth.repository';

@Module({
  imports: [
    DatabaseModule,
    CommonModule,
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'secret',
      signOptions: {
        expiresIn: process.env.JWT_EXPIRATION || '24h',
      },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, UserRepository],
  exports: [AuthService],
})
export class AuthModule {}
