import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../api/api_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = true;
  double _subtotal = 0.0;
  double _total = 0.0;
  double _discount = 0.0;
  String? _couponCode;

  final ApiService _apiService = ApiService();

  CartProvider() {
    _loadCart();
  }

  bool get isLoading => _isLoading;
  List<CartItem> get items => _items;
  double get subtotal => _subtotal;
  double get total => _total;
  double get discount => _discount;
  String? get couponCode => _couponCode;

  int get itemCount => _items.length;
  int get selectedCount => _items.where((item) => item.isSelected).length;

  // Use backend total instead of local calculation
  double get totalAmount => _total;

  Future<void> _loadCart() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _apiService.getCart();
      _parseCartData(data);
    } catch (e) {
      debugPrint('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _parseCartData(Map<String, dynamic> data) {
    final List<dynamic> carts = data['carts'] ?? [];
    _items = carts.map((json) => CartItem.fromBackendJson(json)).toList();

    _subtotal = double.tryParse(data['subtotal']?.toString() ?? '0') ?? 0.0;
    _total = double.tryParse(data['total']?.toString() ?? '0') ?? 0.0;
    _discount = double.tryParse(data['discount']?.toString() ?? '0') ?? 0.0;

    // Try to extract coupon code if available in extra data or separate field
    // Since backend might not return it directly in root, we might need to adjust based on actual response
    // For now we leave it as managed by applyCoupon success
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final skuId = product.defaultSkuId ?? product.id;
      await _apiService.addToCart(skuId, quantity);
      await _loadCart();
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String productId) async {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(id: '', title: '', imageUrl: '', price: 0),
        id: '',
      ),
    );

    if (item.id != null) {
      try {
        await _apiService.removeFromCart(item.id!);
        // Optimistically remove
        _items.removeWhere((i) => i.id == item.id);
        notifyListeners();
        // Reload to get correct totals
        await _loadCart();
      } catch (e) {
        debugPrint('Error removing from cart: $e');
        // Revert if needed, or just reload
        await _loadCart();
      }
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(
        product: Product(id: '', title: '', imageUrl: '', price: 0),
        id: '',
      ),
    );

    if (item.id != null) {
      if (quantity <= 0) {
        await removeFromCart(productId);
      } else {
        try {
          await _apiService.updateCart(item.id!, quantity);
          // Optimistically update
          item.quantity = quantity;
          notifyListeners();
          // Reload to get correct totals
          await _loadCart();
        } catch (e) {
          debugPrint('Error updating cart quantity: $e');
        }
      }
    }
  }

  void toggleSelection(String productId) {
    // Local toggle for UI mostly
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void toggleAll(bool selectAll) {
    for (var item in _items) {
      item.isSelected = selectAll;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _subtotal = 0;
    _total = 0;
    _discount = 0;
    _couponCode = null;
    notifyListeners();
  }

  // Coupon methods
  List<Coupon> _availableCoupons = [];
  bool _isCouponsLoading = false;

  List<Coupon> get availableCoupons => _availableCoupons;
  bool get isCouponsLoading => _isCouponsLoading;

  Future<void> loadCoupons() async {
    if (_isCouponsLoading) return;

    _isCouponsLoading = true;
    // Don't notify yet to avoid UI flicker if it's fast, or do notify if you want spinner
    // notifyListeners();

    try {
      _availableCoupons = await _apiService.getCoupons();
    } catch (e) {
      debugPrint('Error loading coupons: $e');
    } finally {
      _isCouponsLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyCoupon(String code) async {
    try {
      final response = await _apiService.applyCoupon(code);
      if (response['cart'] != null) {
        _parseCartData(response['cart']);
        _couponCode = code;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error applying coupon: $e');
      rethrow;
    }
  }

  Future<void> removeCoupon() async {
    try {
      final response = await _apiService.removeCoupon();
      if (response['cart'] != null) {
        _parseCartData(response['cart']);
        _couponCode = null;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing coupon: $e');
      rethrow;
    }
  }
}
