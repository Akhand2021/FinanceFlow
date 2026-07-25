import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class UtilsService {
  /**
   * Hash password
   */
  async hashPassword(password: string): Promise<string> {
    const salt = await bcrypt.genSalt(10);
    return bcrypt.hash(password, salt);
  }

  /**
   * Compare password with hash
   */
  async comparePassword(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }

  /**
   * Generate UUID
   */
  generateUUID(): string {
    return uuidv4();
  }

  /**
   * Generate random token
   */
  generateRandomToken(length: number = 32): string {
    return require('crypto').randomBytes(length).toString('hex');
  }

  /**
   * Format currency
   */
  formatCurrency(amount: number, currency: string = 'USD'): string {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency,
    }).format(amount);
  }

  /**
   * Parse query params for pagination
   */
  parsePaginationParams(skip?: number, take?: number) {
    return {
      skip: skip || 0,
      take: take || 10,
    };
  }
}
