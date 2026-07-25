import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { LoanEntity, LoanPaymentEntity } from './entities/loan.entity';
import { CreateLoanDto } from './dto/create-loan.dto';
import { UpdateLoanDto } from './dto/update-loan.dto';
import { RecordPaymentDto } from './dto/record-payment.dto';

@Injectable()
export class LoansRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllByUserId(userId: string): Promise<LoanEntity[]> {
    const loans = await this.prisma.loan.findMany({
      where: { userId, deletedAt: null },
      include: {
        payments: {
          orderBy: { createdAt: 'desc' },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
    return loans.map((l) => this.mapToEntity(l));
  }

  async findById(id: string, userId: string): Promise<LoanEntity | null> {
    const loan = await this.prisma.loan.findFirst({
      where: { id, userId, deletedAt: null },
      include: {
        payments: {
          orderBy: { createdAt: 'desc' },
        },
      },
    });
    return loan ? this.mapToEntity(loan) : null;
  }

  async create(userId: string, dto: CreateLoanDto): Promise<LoanEntity> {
    const loan = await this.prisma.loan.create({
      data: {
        userId,
        name: dto.name,
        type: dto.type,
        lender: dto.lender,
        principal: dto.principal,
        currentAmount: dto.currentAmount ?? dto.principal,
        interestRate: dto.interestRate,
        emiAmount: dto.emiAmount,
        startDate: new Date(dto.startDate),
        endDate: dto.endDate ? new Date(dto.endDate) : null,
      },
      include: { payments: true },
    });
    return this.mapToEntity(loan);
  }

  async update(
    id: string,
    userId: string,
    dto: UpdateLoanDto,
  ): Promise<LoanEntity> {
    await this.prisma.loan.updateMany({
      where: { id, userId },
      data: {
        name: dto.name,
        type: dto.type,
        lender: dto.lender,
        principal: dto.principal,
        currentAmount: dto.currentAmount,
        interestRate: dto.interestRate,
        emiAmount: dto.emiAmount,
        startDate: dto.startDate ? new Date(dto.startDate) : undefined,
        endDate: dto.endDate ? new Date(dto.endDate) : undefined,
        updatedAt: new Date(),
      },
    });

    const updated = await this.findById(id, userId);
    return updated!;
  }

  async recordPayment(
    loanId: string,
    dto: RecordPaymentDto,
  ): Promise<LoanEntity> {
    return this.prisma.$transaction(async (tx) => {
      const principalDeduction = dto.principalAmount ?? dto.amount;

      // 1. Create loan payment record
      await tx.loanPayment.create({
        data: {
          loanId,
          accountId: dto.accountId,
          amount: dto.amount,
          principalAmount: dto.principalAmount,
          interestAmount: dto.interestAmount,
          note: dto.note,
          paidDate: dto.paidDate ? new Date(dto.paidDate) : new Date(),
          isPaid: true,
        },
      });

      // 2. Decrement loan current amount
      await tx.loan.update({
        where: { id: loanId },
        data: {
          currentAmount: {
            decrement: principalDeduction,
          },
          updatedAt: new Date(),
        },
      });

      // 3. Deduct payment amount from account balance
      await tx.account.update({
        where: { id: dto.accountId },
        data: {
          balance: {
            decrement: dto.amount,
          },
          updatedAt: new Date(),
        },
      });

      const updatedLoan = await tx.loan.findUnique({
        where: { id: loanId },
        include: {
          payments: {
            orderBy: { createdAt: 'desc' },
          },
        },
      });

      return this.mapToEntity(updatedLoan);
    });
  }

  async softDelete(id: string, userId: string): Promise<void> {
    await this.prisma.loan.updateMany({
      where: { id, userId },
      data: { deletedAt: new Date() },
    });
  }

  private mapToEntity(loan: any): LoanEntity {
    const payments = (loan.payments || []).map(
      (p: any) =>
        new LoanPaymentEntity({
          id: p.id,
          loanId: p.loanId,
          accountId: p.accountId,
          amount: Number(p.amount),
          principalAmount: p.principalAmount ? Number(p.principalAmount) : null,
          interestAmount: p.interestAmount ? Number(p.interestAmount) : null,
          note: p.note,
          dueDate: p.dueDate,
          paidDate: p.paidDate,
          isPaid: p.isPaid,
          createdAt: p.createdAt,
          updatedAt: p.updatedAt,
        }),
    );

    return new LoanEntity({
      id: loan.id,
      userId: loan.userId,
      name: loan.name,
      type: loan.type,
      lender: loan.lender,
      principal: Number(loan.principal),
      currentAmount: Number(loan.currentAmount),
      interestRate: Number(loan.interestRate),
      emiAmount: loan.emiAmount ? Number(loan.emiAmount) : null,
      startDate: loan.startDate,
      endDate: loan.endDate,
      isActive: loan.isActive,
      createdAt: loan.createdAt,
      updatedAt: loan.updatedAt,
      deletedAt: loan.deletedAt,
      payments,
    });
  }
}
