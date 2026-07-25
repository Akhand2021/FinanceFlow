import {
  Controller,
  Get,
  Post,
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
import { MerchantRulesService } from './merchant-rules.service';
import { CreateMerchantRuleDto } from './dto/create-merchant-rule.dto';
import { MerchantRuleResponseDto } from './dto/merchant-rule-response.dto';

@ApiTags('Merchant Rules')
@Controller('merchant-rules')
@UseGuards(JwtGuard)
@ApiBearerAuth()
export class MerchantRulesController {
  constructor(private readonly merchantRulesService: MerchantRulesService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get all merchant categorization rules' })
  @ApiResponse({
    status: 200,
    type: [MerchantRuleResponseDto],
  })
  async getRules(@CurrentUser() user: any): Promise<MerchantRuleResponseDto[]> {
    return this.merchantRulesService.getUserRules(user.sub);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create or update merchant learning rule' })
  @ApiResponse({
    status: 201,
    type: MerchantRuleResponseDto,
  })
  async upsertRule(
    @CurrentUser() user: any,
    @Body() dto: CreateMerchantRuleDto,
  ): Promise<MerchantRuleResponseDto> {
    return this.merchantRulesService.upsertRule(user.sub, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete a merchant rule' })
  @ApiResponse({ status: 200, description: 'Rule deleted successfully' })
  async deleteRule(
    @CurrentUser() user: any,
    @Param('id') id: string,
  ): Promise<{ message: string }> {
    await this.merchantRulesService.deleteRule(id, user.sub);
    return { message: 'Rule deleted successfully' };
  }
}
