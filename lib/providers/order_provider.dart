import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/models.dart';
import '../models/address_model.dart';
import '../api/api_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  List<PaymentMethod> _paymentMethods = [];
  bool _isLoading = true;
  bool _isPaymentLoading = false;
  final ApiService _apiService = ApiService();

  OrderProvider() {
    loadOrders();
    fetchPaymentMethods();
  }

  List<Order> get orders => _orders;
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  bool get isLoading => _isLoading;
  bool get isPaymentLoading => _isPaymentLoading;

  Future<void> fetchPaymentMethods() async {
    _isPaymentLoading = true;
    // notifyListeners(); // Avoid rebuilds during build phase if called from constructor
    try {
      final methods = await _apiService.getPaymentMethods();
      _paymentMethods = methods.map((m) => PaymentMethod.fromJson(m)).toList();
    } catch (e) {
      debugPrint('Error fetching payment methods: $e');
    } finally {
      _isPaymentLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> payOrder(
    String orderId,
    String paymentMethod,
  ) async {
    try {
      return await _apiService.payOrder(orderId, paymentMethod);
    } catch (e) {
      debugPrint('Error paying order: $e');
      rethrow;
    }
  }

  Future<void> loadOrders() async {
    _isLoading = true;
    // notifyListeners(); // Avoid rebuilds during build phase
    try {
      _orders = await _apiService.getOrders();
    } catch (e) {
      debugPrint('Error loading orders: $e');
      // Fallback to local storage if API fails? Or just empty.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Order> placeOrder(
    List<CartItem> items,
    double totalAmount,
    Address shippingAddress,
    String paymentMethod, {
    String? comment,
  }) async {
    try {
      final newOrder = await _apiService.createOrder(
        addressId: shippingAddress.id!,
        paymentMethod: paymentMethod,
        comment: comment,
      );

      _orders.insert(0, newOrder);
      notifyListeners();
      return newOrder;
    } catch (e) {
      debugPrint('Error placing order: $e');
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      final updatedOrder = await _apiService.cancelOrder(orderId);
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cancelling order: $e');
      rethrow;
    }
  }
}
