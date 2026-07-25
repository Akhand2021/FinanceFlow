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
import { SavingsService } from './savings.service';
import { CreateGoalDto } from './dto/create-goal.dto';
import { UpdateGoalDto } from './dto/update-goal.dto';
import { AddContributionDto } from './dto/add-contribution.dto';
import { GoalResponseDto } from './dto/goal-response.dto';

@ApiTags('Savings')
@Controller('savings')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class SavingsController {
  constructor(private readonly savingsService: SavingsService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all user savings goals' })
  @ApiResponse({
    status: 200,
    description: 'Savings goals retrieved successfully',
    type: [GoalResponseDto],
  })
  async getGoals(@CurrentUser() user: any): Promise<GoalResponseDto[]> {
    return this.savingsService.getUserGoals(user.sub);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get savings goal details by ID' })
  @ApiResponse({
    status: 200,
    description: 'Savings goal details retrieved',
    type: GoalResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Goal not found' })
  async getGoalById(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<GoalResponseDto> {
    return this.savingsService.getGoalById(id, user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new savings goal' })
  @ApiResponse({
    status: 201,
    description: 'Savings goal created successfully',
    type: GoalResponseDto,
  })
  async createGoal(
    @CurrentUser() user: any,
    @Body() dto: CreateGoalDto,
  ): Promise<GoalResponseDto> {
    return this.savingsService.createGoal(user.sub, dto);
  }

  @Post(':id/contribute')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Add a contribution to a savings goal' })
  @ApiResponse({
    status: 200,
    description: 'Contribution added and goal currentAmount updated atomically',
    type: GoalResponseDto,
  })
  async addContribution(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: AddContributionDto,
  ): Promise<GoalResponseDto> {
    return this.savingsService.addContribution(id, user.sub, dto);
  }

  @Put(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update a savings goal' })
  @ApiResponse({
    status: 200,
    description: 'Savings goal updated successfully',
    type: GoalResponseDto,
  })
  async updateGoal(
    @CurrentUser() user: any,
    @Param('id') id: string,
    @Body() dto: UpdateGoalDto,
  ): Promise<GoalResponseDto> {
    return this.savingsService.updateGoal(id, user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft delete a savings goal' })
  @ApiResponse({ status: 200, description: 'Goal deleted successfully' })
  async deleteGoal(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<{ message: string }> {
    await this.savingsService.deleteGoal(id, user.sub);
    return { message: 'Goal deleted successfully' };
  }
}
