import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { CategoriesRepository } from './categories.repository';
import { CategoryEntity } from './entities/category.entity';
import { CategoryType, CreateCategoryDto } from './dto/create-category.dto';
import { NotFoundException } from '@common/exceptions/api.exception';

describe('CategoriesService', () => {
  let service: CategoriesService;
  let repository: CategoriesRepository;

  const mockCategory = new CategoryEntity({
    id: 'category-123',
    userId: 'user-123',
    name: 'Food',
    type: CategoryType.EXPENSE,
    isDefault: true,
    isActive: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  });

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        {
          provide: CategoriesRepository,
          useValue: {
            findAllByUserId: jest.fn(),
            findById: jest.fn(),
            create: jest.fn(),
            update: jest.fn(),
            softDelete: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
    repository = module.get<CategoriesRepository>(CategoriesRepository);
  });

  it('should return all categories for user', async () => {
    jest.spyOn(repository, 'findAllByUserId').mockResolvedValue([mockCategory]);
    const result = await service.getUserCategories('user-123');
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Food');
  });

  it('should return category by ID', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(mockCategory);
    const result = await service.getCategoryById('category-123', 'user-123');
    expect(result.id).toBe('category-123');
  });

  it('should throw NotFoundException if category does not exist', async () => {
    jest.spyOn(repository, 'findById').mockResolvedValue(null);
    await expect(
      service.getCategoryById('invalid-id', 'user-123'),
    ).rejects.toThrow(NotFoundException);
  });

  it('should create new category', async () => {
    const dto: CreateCategoryDto = {
      name: 'Crypto',
      type: CategoryType.INCOME,
    };
    jest.spyOn(repository, 'create').mockResolvedValue(mockCategory);
    const result = await service.createCategory('user-123', dto);
    expect(result).toBeDefined();
    expect(repository.create).toHaveBeenCalledWith('user-123', dto);
  });
});
