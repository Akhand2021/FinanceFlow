import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';

@ApiTags('Health & Status')
@Controller()
export class AppController {
  @Get()
  @ApiOperation({ summary: 'API Root & Health Check' })
  @ApiResponse({ status: 200, description: 'Service is healthy and operational.' })
  getHealthStatus() {
    return {
      status: 'ok',
      service: 'FinanceFlow REST API Engine',
      version: '1.0.0',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    };
  }

  @Get('health')
  @ApiOperation({ summary: 'Cloud Load Balancer Health Probe' })
  @ApiResponse({ status: 200, description: 'Health check probe passed.' })
  getHealthProbe() {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
    };
  }
}
