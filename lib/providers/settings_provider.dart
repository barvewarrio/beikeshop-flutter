import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SettingsProvider extends ChangeNotifier {
  String _languageCode = 'en';
  String _currencyCode = 'USD';

  // Exchange rates (Mock)
  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'CNY': 7.2,
    'EUR': 0.92,
  };

  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'CNY': '¥',
    'EUR': '€',
  };

  SettingsProvider() {
    _loadSettings();
  }

  String get languageCode => _languageCode;
  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbols[_currencyCode] ?? '\$';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('language_code') ?? 'en';
    _currencyCode = prefs.getString('currency_code') ?? 'USD';
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
    notifyListeners();
  }

  Future<void> setCurrency(String code) async {
    _currencyCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', code);
    notifyListeners();
  }

  // Helper to format price based on selected currency
  String formatPrice(double amountInUSD) {
    double rate = _exchangeRates[_currencyCode] ?? 1.0;
    double convertedAmount = amountInUSD * rate;

    final format = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    return format.format(convertedAmount);
  }
}
