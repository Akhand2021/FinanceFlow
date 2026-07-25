import { NestFactory } from '@nestjs/core';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { ValidationPipe } from '@nestjs/common';

import { AppModule } from './app.module';
import { HttpExceptionFilter } from '@common/filters/http-exception.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Enable CORS
  app.enableCors({
    origin: process.env.CORS_ORIGIN?.split(',') || '*',
    credentials: true,
  });

  // Global prefix with root healthcheck exclusions for cloud load balancers
  app.setGlobalPrefix('api/v1', {
    exclude: ['/', '/health'],
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  // Global exception filter
  app.useGlobalFilters(new HttpExceptionFilter());

  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('FinanceFlow API')
    .setDescription('Personal Finance Management API - Track. Save. Grow.')
    .setVersion('1.0.0')
    .addBearerAuth()
    .addTag('Health & Status')
    .addTag('Auth')
    .addTag('Users')
    .addTag('Accounts')
    .addTag('Transactions')
    .addTag('Categories')
    .addTag('Budgets')
    .addTag('Savings')
    .addTag('Loans')
    .addTag('Reports')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = parseInt(process.env.PORT || '3000', 10);
  await app.listen(port);

  console.log(`✅ FinanceFlow API running on port ${port}`);
  console.log(`📚 Swagger docs available at http://localhost:${port}/api/docs`);
}

bootstrap().catch((err) => {
  console.error('❌ Failed to start application:', err);
  process.exit(1);
});
