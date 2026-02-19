import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/models.dart';

class WishlistProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WishlistItem> _wishlist = [];
  bool _isLoading = false;
  String? _error;

  WishlistProvider() {
    fetchWishlist();
  }

  List<WishlistItem> get wishlist => _wishlist;
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
      // Optimistic update - create a temporary item
      // We don't have the ID yet, so we use a placeholder or wait for refresh
      // For now, let's just add it and then refresh to get the ID
      await _apiService.addToWishlist(product.id);
      await fetchWishlist();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    final existingIndex = _wishlist.indexWhere((item) => item.product.id == productId);
    if (existingIndex == -1) return;

    final removedItem = _wishlist[existingIndex];

    try {
      // Optimistic update
      _wishlist.removeAt(existingIndex);
      notifyListeners();

      await _apiService.removeFromWishlist(removedItem.id);
    } catch (e) {
      // Revert if failed
      _wishlist.insert(existingIndex, removedItem);
      notifyListeners();
      rethrow;
    }
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((item) => item.product.id == productId);
  }
}
