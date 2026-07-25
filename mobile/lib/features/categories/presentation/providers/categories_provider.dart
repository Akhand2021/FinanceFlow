import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/category_entity.dart';
import '../../data/datasources/categories_remote_datasource.dart';
import '../../../../core/services/api_client.dart';

final categoriesDatasourceProvider = Provider<CategoriesRemoteDatasource>((ref) {
  final dio = ref.watch(apiClientProvider);
  return CategoriesRemoteDatasourceImpl(dio: dio);
});

class CategoriesNotifier extends StateNotifier<AsyncValue<List<CategoryEntity>>> {
  final CategoriesRemoteDatasource datasource;

  CategoriesNotifier({required this.datasource}) : super(const AsyncValue.loading()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await datasource.getCategories();
      state = AsyncValue.data(categories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addCategory(Map<String, dynamic> data) async {
    try {
      await datasource.createCategory(data);
      await fetchCategories();
    } catch (e) {
      rethrow;
    }
  }
}

final categoriesNotifierProvider =
    StateNotifierProvider<CategoriesNotifier, AsyncValue<List<CategoryEntity>>>((ref) {
  final datasource = ref.watch(categoriesDatasourceProvider);
  return CategoriesNotifier(datasource: datasource);
});
