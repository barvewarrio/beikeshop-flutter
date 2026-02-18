import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../api/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  AuthProvider() {
    _loadUser();
  }

  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  User? get user => _user;

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      final String? userId = prefs.getString('user_id');
      final String? userName = prefs.getString('user_name');
      final String? userEmail = prefs.getString('user_email');
      
      if (token != null && userId != null) {
        // Verify token with backend or just load from cache
        // ideally we should call getUser() to verify token validity
        // For now, let's try to fetch fresh user data
        try {
          _user = await _apiService.getUser();
        } catch (e) {
          // If token invalid, clear it
          debugPrint('Token invalid or error fetching user: $e');
          await logout(); 
          return;
        }

        // If fetch failed but we want to use cached data (offline mode support?)
        // _user = User(
        //   id: userId,
        //   email: userEmail ?? '',
        //   name: userName ?? 'User',
        //   token: token,
        // );
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final user = await _apiService.login(email, password);
      _user = user;
      
      final prefs = await SharedPreferences.getInstance();
      if (user.token != null) {
        await prefs.setString('auth_token', user.token!);
      }
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login failed: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final user = await _apiService.register(name, email, password);
      _user = user;
      
      final prefs = await SharedPreferences.getInstance();
      if (user.token != null) {
        await prefs.setString('auth_token', user.token!);
      }
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Registration failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    }

    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    notifyListeners();
  }
}
