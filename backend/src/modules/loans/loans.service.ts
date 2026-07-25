import { Injectable } from '@nestjs/common';
import { LoansRepository } from './loans.repository';
import { CreateLoanDto } from './dto/create-loan.dto';
import { UpdateLoanDto } from './dto/update-loan.dto';
import { RecordPaymentDto } from './dto/record-payment.dto';
import { LoanEntity } from './entities/loan.entity';
import { NotFoundException } from '@common/exceptions/api.exception';

@Injectable()
export class LoansService {
  constructor(private readonly loansRepository: LoansRepository) {}

  async getUserLoans(userId: string): Promise<LoanEntity[]> {
    return this.loansRepository.findAllByUserId(userId);
  }

  async getLoanById(id: string, userId: string): Promise<LoanEntity> {
    const loan = await this.loansRepository.findById(id, userId);
    if (!loan) {
      throw new NotFoundException('Loan');
    }
    return loan;
  }

  async createLoan(userId: string, dto: CreateLoanDto): Promise<LoanEntity> {
    return this.loansRepository.create(userId, dto);
  }

  async updateLoan(
    id: string,
    userId: string,
    dto: UpdateLoanDto,
  ): Promise<LoanEntity> {
    await this.getLoanById(id, userId);
    return this.loansRepository.update(id, userId, dto);
  }

  async recordPayment(
    id: string,
    userId: string,
    dto: RecordPaymentDto,
  ): Promise<LoanEntity> {
    await this.getLoanById(id, userId);
    return this.loansRepository.recordPayment(id, dto);
  }

  async deleteLoan(id: string, userId: string): Promise<void> {
    await this.getLoanById(id, userId);
    await this.loansRepository.softDelete(id, userId);
  }
}
