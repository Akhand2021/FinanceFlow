import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { UtilsService } from './utils/utils.service';
import { JwtGuard } from './guards/jwt.guard';

@Module({
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'dev_jwt_secret_key_change_in_production',
      signOptions: { expiresIn: '24h' },
    }),
  ],
  providers: [UtilsService, JwtGuard],
  exports: [UtilsService, JwtModule, JwtGuard],
})
export class CommonModule {}
