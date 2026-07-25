import { Injectable } from '@nestjs/common';
import { CategoriesRepository } from './categories.repository';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { CategoryEntity } from './entities/category.entity';
import { NotFoundException, ConflictException } from '@common/exceptions/api.exception';

@Injectable()
export class CategoriesService {
  constructor(private readonly categoriesRepository: CategoriesRepository) {}

  async getUserCategories(userId: string): Promise<CategoryEntity[]> {
    return this.categoriesRepository.findAllByUserId(userId);
  }

  async getCategoryById(id: string, userId: string): Promise<CategoryEntity> {
    const category = await this.categoriesRepository.findById(id, userId);
    if (!category) {
      throw new NotFoundException('Category');
    }
    return category;
  }

  async createCategory(
    userId: string,
    dto: CreateCategoryDto,
  ): Promise<CategoryEntity> {
    try {
      return await this.categoriesRepository.create(userId, dto);
    } catch (err: any) {
      if (err?.code === 'P2002') {
        throw new ConflictException('Category name already exists');
      }
      throw err;
    }
  }

  async updateCategory(
    id: string,
    userId: string,
    dto: UpdateCategoryDto,
  ): Promise<CategoryEntity> {
    await this.getCategoryById(id, userId);
    return this.categoriesRepository.update(id, userId, dto);
  }

  async deleteCategory(id: string, userId: string): Promise<void> {
    await this.getCategoryById(id, userId);
    await this.categoriesRepository.softDelete(id, userId);
  }
}
