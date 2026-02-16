import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? 'User',
      avatar: json['avatar'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'token': token,
    };
  }
}

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = true;

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
        _user = User(
          id: userId,
          email: userEmail ?? '',
          name: userName ?? 'User',
          token: token,
        );
      }
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock login success
      final mockUser = User(
        id: '123',
        email: email,
        name: 'Demo User',
        token: 'mock_token_123',
      );
      
      _user = mockUser;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', mockUser.token!);
      await prefs.setString('user_id', mockUser.id);
      await prefs.setString('user_name', mockUser.name);
      await prefs.setString('user_email', mockUser.email);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock register success
      final mockUser = User(
        id: '124',
        email: email,
        name: name,
        token: 'mock_token_124',
      );
      
      _user = mockUser;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', mockUser.token!);
      await prefs.setString('user_id', mockUser.id);
      await prefs.setString('user_name', mockUser.name);
      await prefs.setString('user_email', mockUser.email);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    notifyListeners();
  }
}
