import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/models.dart';

class WishlistProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _wishlist = [];
  bool _isLoading = false;
  String? _error;

  WishlistProvider() {
    fetchWishlist();
  }

  List<Product> get wishlist => _wishlist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWishlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _wishlist = await _apiService.getWishlist();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToWishlist(Product product) async {
    try {
      // Optimistic update
      if (!_wishlist.any((p) => p.id == product.id)) {
        _wishlist.add(product);
        notifyListeners();
      }

      await _apiService.addToWishlist(product.id);
    } catch (e) {
      // Revert if failed
      _wishlist.removeWhere((p) => p.id == product.id);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final existingIndex = _wishlist.indexWhere((p) => p.id == productId);
    if (existingIndex == -1) return;

    final removedProduct = _wishlist[existingIndex];

    try {
      // Optimistic update
      _wishlist.removeAt(existingIndex);
      notifyListeners();

      await _apiService.removeFromWishlist(productId);
    } catch (e) {
      // Revert if failed
      _wishlist.insert(existingIndex, removedProduct);
      notifyListeners();
      rethrow;
    }
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((p) => p.id == productId);
  }
}
