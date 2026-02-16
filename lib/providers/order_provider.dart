import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';
import '../models/address_model.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = true;

  OrderProvider() {
    _loadOrders();
  }

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? ordersJson = prefs.getString('user_orders');

      if (ordersJson != null) {
        final List<dynamic> decodedList = jsonDecode(ordersJson);
        _orders = decodedList.map((item) => Order.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String ordersJson = jsonEncode(
        _orders.map((item) => item.toJson()).toList(),
      );
      await prefs.setString('user_orders', ordersJson);
    } catch (e) {
      print('Error saving orders: $e');
    }
  }

  Future<Order> placeOrder(
    List<CartItem> items,
    double totalAmount,
    Address shippingAddress,
    String paymentMethod,
  ) async {
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      date: DateTime.now(),
      status: 'Pending',
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, newOrder);
    await _saveOrders();
    notifyListeners();

    return newOrder;
  }
}
