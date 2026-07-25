import { Injectable } from '@nestjs/common';
import { PrismaService } from '@database/prisma.service';
import { CategoryEntity } from './entities/category.entity';
import { CategoryType, CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';

const DEFAULT_CATEGORIES = [
  { name: 'Food', type: CategoryType.EXPENSE, icon: 'restaurant', color: '0xFFFF6B6B' },
  { name: 'Shopping', type: CategoryType.EXPENSE, icon: 'shopping_cart', color: '0xFF4ECDC4' },
  { name: 'Medical', type: CategoryType.EXPENSE, icon: 'local_hospital', color: '0xFFFF9F43' },
  { name: 'Bills', type: CategoryType.EXPENSE, icon: 'receipt', color: '0xFFEE5253' },
  { name: 'Fuel', type: CategoryType.EXPENSE, icon: 'local_gas_station', color: '0xFF10AC84' },
  { name: 'Travel', type: CategoryType.EXPENSE, icon: 'flight', color: '0xFF54A0FF' },
  { name: 'Salary', type: CategoryType.INCOME, icon: 'payments', color: '0xFF2ECC71' },
  { name: 'Business', type: CategoryType.INCOME, icon: 'business_center', color: '0xFF341F97' },
  { name: 'Investment', type: CategoryType.INCOME, icon: 'show_chart', color: '0xFF00D2D3' },
  { name: 'Entertainment', type: CategoryType.EXPENSE, icon: 'movie', color: '0xFF5F27CD' },
  { name: 'Education', type: CategoryType.EXPENSE, icon: 'school', color: '0xFFFF9F1A' },
  { name: 'Health', type: CategoryType.EXPENSE, icon: 'fitness_center', color: '0xFF2E86DE' },
];

@Injectable()
export class CategoriesRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAllByUserId(userId: string): Promise<CategoryEntity[]> {
    let categories = await this.prisma.category.findMany({
      where: { userId, deletedAt: null },
      orderBy: { name: 'asc' },
    });

    // Auto-seed default categories if user has none
    if (categories.length === 0) {
      await this.seedDefaultCategories(userId);
      categories = await this.prisma.category.findMany({
        where: { userId, deletedAt: null },
        orderBy: { name: 'asc' },
      });
    }

    return categories.map((cat) => this.mapToEntity(cat));
  }

  async findById(id: string, userId: string): Promise<CategoryEntity | null> {
    const category = await this.prisma.category.findFirst({
      where: { id, userId, deletedAt: null },
    });
    return category ? this.mapToEntity(category) : null;
  }

  async create(userId: string, dto: CreateCategoryDto): Promise<CategoryEntity> {
    const category = await this.prisma.category.create({
      data: {
        userId,
        name: dto.name,
        type: dto.type,
        icon: dto.icon,
        color: dto.color ?? '0xFF8E8DFF',
        isDefault: dto.isDefault ?? false,
      },
    });

    return this.mapToEntity(category);
  }

  async update(
    id: string,
    userId: string,
    dto: UpdateCategoryDto,
  ): Promise<CategoryEntity> {
    await this.prisma.category.updateMany({
      where: { id, userId },
      data: {
        ...dto,
        updatedAt: new Date(),
      },
    });

    const updated = await this.findById(id, userId);
    return updated!;
  }

  async softDelete(id: string, userId: string): Promise<void> {
    await this.prisma.category.updateMany({
      where: { id, userId },
      data: { deletedAt: new Date() },
    });
  }

  private async seedDefaultCategories(userId: string): Promise<void> {
    await this.prisma.category.createMany({
      data: DEFAULT_CATEGORIES.map((cat) => ({
        userId,
        name: cat.name,
        type: cat.type,
        icon: cat.icon,
        color: cat.color,
        isDefault: true,
      })),
      skipDuplicates: true,
    });
  }

  private mapToEntity(category: any): CategoryEntity {
    return new CategoryEntity({
      id: category.id,
      userId: category.userId,
      name: category.name,
      type: category.type,
      icon: category.icon,
      color: category.color,
      isDefault: category.isDefault,
      isActive: category.isActive,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      deletedAt: category.deletedAt,
    });
  }
}
