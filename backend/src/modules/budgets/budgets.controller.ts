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
import { BudgetsService } from './budgets.service';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';
import { BudgetResponseDto } from './dto/budget-response.dto';

@ApiTags('Budgets')
@Controller('budgets')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class BudgetsController {
  constructor(private readonly budgetsService: BudgetsService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all user budgets' })
  @ApiResponse({
    status: 200,
    description: 'Budgets list retrieved successfully',
    type: [BudgetResponseDto],
  })
  async getBudgets(@CurrentUser() user: any): Promise<BudgetResponseDto[]> {
    return this.budgetsService.getUserBudgets(user.sub);
  }

  @Get('current')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get budget for current month' })
  @ApiResponse({
    status: 200,
    description: 'Current budget retrieved',
    type: BudgetResponseDto,
  })
  async getCurrentBudget(@CurrentUser() user: any): Promise<BudgetResponseDto | null> {
    return this.budgetsService.getCurrentBudget(user.sub);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get budget by ID' })
  @ApiResponse({
    status: 200,
    description: 'Budget details retrieved',
    type: BudgetResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Budget not found' })
  async getBudgetById(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<BudgetResponseDto> {
    return this.budgetsService.getBudgetById(id, user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a monthly budget with category limit items' })
  @ApiResponse({
    status: 201,
    description: 'Budget created successfully',
    type: BudgetResponseDto,
  })
  async createBudget(
    @CurrentUser() user: any,
    @Body() dto: CreateBudgetDto,
  ): Promise<BudgetResponseDto> {
    return this.budgetsService.createBudget(user.sub, dto);
  }

  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update a budget' })
  @ApiResponse({
    status: 200,
    description: 'Budget updated successfully',
    type: BudgetResponseDto,
  })
  async updateBudget(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: UpdateBudgetDto,
  ): Promise<BudgetResponseDto> {
    return this.budgetsService.updateBudget(id, user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft delete a budget' })
  @ApiResponse({ status: 200, description: 'Budget deleted successfully' })
  async deleteBudget(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<{ message: string }> {
    await this.budgetsService.deleteBudget(id, user.sub);
    return { message: 'Budget deleted successfully' };
  }
}
