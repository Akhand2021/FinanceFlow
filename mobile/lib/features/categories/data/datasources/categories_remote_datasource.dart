import 'package:dio/dio.dart';
import '../models/category_model.dart';

abstract class CategoriesRemoteDatasource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<CategoryModel> createCategory(Map<String, dynamic> data);
  Future<CategoryModel> updateCategory(String id, Map<String, dynamic> data);
  Future<void> deleteCategory(String id);
}

class CategoriesRemoteDatasourceImpl implements CategoriesRemoteDatasource {
  final Dio dio;

  CategoriesRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get('/categories');
    final List list = response.data['data'];
    return list.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final response = await dio.get('/categories/$id');
    return CategoryModel.fromJson(response.data['data']);
  }

  @override
  Future<CategoryModel> createCategory(Map<String, dynamic> data) async {
    final response = await dio.post('/categories', data: data);
    return CategoryModel.fromJson(response.data['data']);
  }

  @override
  Future<CategoryModel> updateCategory(String id, Map<String, dynamic> data) async {
    final response = await dio.put('/categories/$id', data: data);
    return CategoryModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await dio.delete('/categories/$id');
  }
}
