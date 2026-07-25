import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { JwtGuard } from '@common/guards/jwt.guard';
import { CurrentUser } from '@common/decorators/current-user.decorator';
import { LoansService } from './loans.service';
import { CreateLoanDto } from './dto/create-loan.dto';
import { UpdateLoanDto } from './dto/update-loan.dto';
import { RecordPaymentDto } from './dto/record-payment.dto';
import { LoanResponseDto } from './dto/loan-response.dto';

@ApiTags('Loans')
@Controller('loans')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class LoansController {
  constructor(private readonly loansService: LoansService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all user loans and EMI tracking' })
  @ApiResponse({
    status: 200,
    description: 'Loans list retrieved successfully',
    type: [LoanResponseDto],
  })
  async getLoans(@CurrentUser() user: any): Promise<LoanResponseDto[]> {
    return this.loansService.getUserLoans(user.sub);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get loan details by ID' })
  @ApiResponse({
    status: 200,
    description: 'Loan details retrieved',
    type: LoanResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Loan not found' })
  async getLoanById(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<LoanResponseDto> {
    return this.loansService.getLoanById(id, user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new loan (Home, Car, Personal, Borrowed, etc.)' })
  @ApiResponse({
    status: 201,
    description: 'Loan created successfully',
    type: LoanResponseDto,
  })
  async createLoan(
    @CurrentUser() user: any,
    @Body() dto: CreateLoanDto,
  ): Promise<LoanResponseDto> {
    return this.loansService.createLoan(user.sub, dto);
  }

  @Post(':id/payment')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Record an EMI payment and update account balance atomically' })
  @ApiResponse({
    status: 200,
    description: 'Payment recorded and account balance deducted atomically',
    type: LoanResponseDto,
  })
  async recordPayment(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: RecordPaymentDto,
  ): Promise<LoanResponseDto> {
    return this.loansService.recordPayment(id, user.sub, dto);
  }

  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update a loan details' })
  @ApiResponse({
    status: 200,
    description: 'Loan updated successfully',
    type: LoanResponseDto,
  })
  async updateLoan(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: UpdateLoanDto,
  ): Promise<LoanResponseDto> {
    return this.loansService.updateLoan(id, user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft delete a loan' })
  @ApiResponse({ status: 200, description: 'Loan deleted successfully' })
  async deleteLoan(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<{ message: string }> {
    await this.loansService.deleteLoan(id, user.sub);
    return { message: 'Loan deleted successfully' };
  }
}
