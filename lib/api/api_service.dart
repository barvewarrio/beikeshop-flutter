import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../models/models.dart';
import '../models/address_model.dart';
import '../models/order_model.dart';
import 'client.dart';
import 'endpoints.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Dio _dio = ApiClient.instance;

  // --- Auth ---

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data;
      final userJson = data['user'];
      userJson['token'] = data['access_token'];
      return User.fromJson(userJson);
    } catch (e) {
      debugPrint('Error logging in: $e');
      rethrow;
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      );
      final data = response.data;
      final userJson = data['user'];
      userJson['token'] = data['access_token'];
      return User.fromJson(userJson);
    } catch (e) {
      debugPrint('Error registering: $e');
      rethrow;
    }
  }

  Future<User> getUser() async {
    try {
      final response = await _dio.get(ApiEndpoints.user);
      return User.fromJson(response.data);
    } catch (e) {
      debugPrint('Error fetching user: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  // --- Categories ---
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      rethrow;
    }
  }

  // --- Products ---
  Future<List<Product>> getProducts({
    int page = 1,
    int limit = 20,
    String? keyword,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};
      if (keyword != null && keyword.isNotEmpty) {
        queryParams['keyword'] = keyword;
      }

      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
      rethrow;
    }
  }

  Future<Product> getProductDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productDetail(id));
      return Product.fromJson(response.data['data']);
    } catch (e) {
      debugPrint('Error fetching product detail: $e');
      rethrow;
    }
  }

  // --- Cart ---
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _dio.get(ApiEndpoints.cart);
      // Return the full response data which includes carts, totals, etc.
      return response.data;
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      rethrow;
    }
  }

  Future<void> addToCart(String skuId, int quantity) async {
    try {
      await _dio.post(
        ApiEndpoints.cart,
        data: {'sku_id': skuId, 'quantity': quantity},
      );
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> updateCart(String cartId, int quantity) async {
    try {
      await _dio.put(
        '${ApiEndpoints.cart}/$cartId',
        data: {'quantity': quantity},
      );
    } catch (e) {
      debugPrint('Error updating cart: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String cartId) async {
    try {
      await _dio.delete('${ApiEndpoints.cart}/$cartId');
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      rethrow;
    }
  }

  // Address
  Future<List<Address>> getAddresses() async {
    try {
      final response = await _dio.get('${ApiEndpoints.baseUrl}/addresses');
      final List<dynamic> data = response.data;
      return data.map((json) => Address.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
      rethrow;
    }
  }

  Future<Address> addAddress(Address address) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.baseUrl}/addresses',
        data: address.toJson(),
      );
      return Address.fromJson(response.data);
    } catch (e) {
      debugPrint('Error adding address: $e');
      rethrow;
    }
  }

  Future<Address> updateAddress(Address address) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.baseUrl}/addresses/${address.id}',
        data: address.toJson(),
      );
      return Address.fromJson(response.data);
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete('${ApiEndpoints.baseUrl}/addresses/$id');
    } catch (e) {
      debugPrint('Error deleting address: $e');
      rethrow;
    }
  }

  // --- Region (Country/Zone) ---
  Future<List<Country>> getCountries() async {
    try {
      final response = await _dio.get(ApiEndpoints.countries);
      final List<dynamic> data = response.data;
      return data.map((json) => Country.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching countries: $e');
      rethrow;
    }
  }

  Future<List<Zone>> getZones(int countryId) async {
    try {
      final response = await _dio.get(ApiEndpoints.countryZones(countryId));
      final List<dynamic> zones = response.data;
      return zones.map((json) => Zone.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching zones: $e');
      rethrow;
    }
  }

  // --- Orders ---
  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get(ApiEndpoints.orders);
      // Backend returns paginated response: { "data": [...], "current_page": 1, ... }
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<Order> createOrder({
    required String addressId,
    required String paymentMethod,
    String? comment,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.orders,
        data: {
          'address_id': addressId,
          'payment_method': paymentMethod,
          'comment': comment,
        },
      );
      return Order.fromJson(response.data);
    } catch (e) {
      debugPrint('Error creating order: $e');
      rethrow;
    }
  }

  // --- Payment ---
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    try {
      final response = await _dio.get(ApiEndpoints.paymentMethods);
      final List<dynamic> data = response.data['data'] ?? [];
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> payOrder(
    String orderId,
    String paymentMethod,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.paymentPay,
        data: {'order_id': orderId, 'payment_method': paymentMethod},
      );
      return response.data['data'] ?? {};
    } catch (e) {
      debugPrint('Error processing payment: $e');
      rethrow;
    }
  }

  // --- Reviews ---
  Future<Map<String, dynamic>> getReviews(
    String productId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reviews,
        queryParameters: {'product_id': productId, 'page': page},
      );

      return response.data;
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      rethrow;
    }
  }

  Future<void> submitReview(
    String productId,
    int rating,
    String comment, {
    List<String>? images,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.reviews,
        data: {
          'product_id': productId,
          'rating': rating,
          'review': comment,
          if (images != null) 'images': images,
        },
      );
    } catch (e) {
      debugPrint('Error submitting review: $e');
      rethrow;
    }
  }

  // --- Wishlist ---
  Future<List<Product>> getWishlist() async {
    try {
      final response = await _dio.get(ApiEndpoints.wishlist);
      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) {
            if (json['product'] != null) {
              return Product.fromJson(json['product']);
            }
            return null;
          })
          .whereType<Product>()
          .toList();
    } catch (e) {
      debugPrint('Error fetching wishlist: $e');
      rethrow;
    }
  }

  Future<void> addToWishlist(String productId) async {
    try {
      await _dio.post(ApiEndpoints.wishlist, data: {'product_id': productId});
    } catch (e) {
      debugPrint('Error adding to wishlist: $e');
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _dio.delete('${ApiEndpoints.wishlist}/$productId');
    } catch (e) {
      debugPrint('Error removing from wishlist: $e');
      rethrow;
    }
  }

  // --- Coupons ---
  Future<List<Coupon>> getCoupons() async {
    try {
      final response = await _dio.get(ApiEndpoints.coupons);
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Coupon.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching coupons: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> applyCoupon(String code) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.cartCoupon,
        data: {'code': code},
      );
      return response.data;
    } catch (e) {
      debugPrint('Error applying coupon: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> removeCoupon() async {
    try {
      final response = await _dio.delete(ApiEndpoints.cartCoupon);
      return response.data;
    } catch (e) {
      debugPrint('Error removing coupon: $e');
      rethrow;
    }
  }

  // --- RMA ---
  Future<List<RmaReason>> getRmaReasons() async {
    try {
      final response = await _dio.get(ApiEndpoints.rmaReasons);
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => RmaReason.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching RMA reasons: $e');
      rethrow;
    }
  }

  Future<List<Rma>> getRmas() async {
    try {
      final response = await _dio.get(ApiEndpoints.rmas);
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => Rma.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching RMAs: $e');
      rethrow;
    }
  }

  Future<Rma> createRma(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(ApiEndpoints.rmas, data: data);
      return Rma.fromJson(response.data['data']);
    } catch (e) {
      debugPrint('Error creating RMA: $e');
      rethrow;
    }
  }

  Future<Rma> getRmaDetail(String id) async {
    try {
      final response = await _dio.get(ApiEndpoints.rmaDetail(id));
      return Rma.fromJson(response.data['data']);
    } catch (e) {
      debugPrint('Error fetching RMA detail: $e');
      rethrow;
    }
  }
}
