import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_INTERCEPTOR } from '@nestjs/core';

import { DatabaseModule } from '@database/database.module';
import { CommonModule } from '@common/common.module';
import { ResponseInterceptor } from '@common/interceptors/response.interceptor';
import { AuthModule } from '@modules/auth/auth.module';
import { AccountsModule } from '@modules/accounts/accounts.module';
import { CategoriesModule } from '@modules/categories/categories.module';
import { TransactionsModule } from '@modules/transactions/transactions.module';
import { BudgetsModule } from '@modules/budgets/budgets.module';
import { SavingsModule } from '@modules/savings/savings.module';
import { LoansModule } from '@modules/loans/loans.module';
import { MerchantRulesModule } from '@modules/merchant-rules/merchant-rules.module';
import { SmsReviewModule } from '@modules/sms-review/sms-review.module';
import { ReportsModule } from '@modules/reports/reports.module';
import { UsersModule } from '@modules/users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    DatabaseModule,
    CommonModule,
    AuthModule,
    AccountsModule,
    CategoriesModule,
    TransactionsModule,
    BudgetsModule,
    SavingsModule,
    LoansModule,
    MerchantRulesModule,
    SmsReviewModule,
    ReportsModule,
    UsersModule,
  ],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseInterceptor,
    },
  ],
})
export class AppModule {}
