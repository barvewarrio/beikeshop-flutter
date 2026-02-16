import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      isSelected: json['isSelected'] ?? true,
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = true;

  CartProvider() {
    _loadCart();
  }

  bool get isLoading => _isLoading;
  List<CartItem> get items => _items;

  int get itemCount => _items.length;
  
  int get selectedCount => _items.where((item) => item.isSelected).length;

  double get totalAmount => _items
      .where((item) => item.isSelected)
      .fold(0.0, (sum, item) => sum + item.totalPrice);

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString('cart_items');
      
      if (cartJson != null) {
        final List<dynamic> decodedList = jsonDecode(cartJson);
        _items = decodedList.map((item) => CartItem.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson = jsonEncode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_items', cartJson);
    } catch (e) {
      print('Error saving cart: $e');
    }
  }

  void addToCart(Product product, {int quantity = 1}) {
    // Check if item already exists
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    _saveCart();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        _items[index].quantity = quantity;
        _saveCart();
        notifyListeners();
      }
    }
  }

  void toggleSelection(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      _saveCart();
      notifyListeners();
    }
  }

  void toggleAll(bool selectAll) {
    for (var item in _items) {
      item.isSelected = selectAll;
    }
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }
}
