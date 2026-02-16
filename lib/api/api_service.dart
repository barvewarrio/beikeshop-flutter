import 'package:dio/dio.dart';
import '../models/models.dart';
import 'client.dart';
import 'endpoints.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = ApiClient.instance;

  // Categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  // Products
  Future<List<Product>> getProducts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }
  
  // Product Detail
  Future<Product> getProductDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productDetail(id));
      return Product.fromJson(response.data['data']);
    } catch (e) {
      print('Error fetching product detail: $e');
      rethrow;
    }
  }
}
