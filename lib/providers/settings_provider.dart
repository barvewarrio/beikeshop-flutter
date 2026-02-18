import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SettingsProvider extends ChangeNotifier {
  String _languageCode = 'zh'; // Default to Chinese
  String _currencyCode = 'CNY'; // Default to CNY

  // Exchange rates (Mock - Base USD)
  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'CNY': 7.20, // China
    'EUR': 0.92, // Europe
    'VND': 24500.0, // Vietnam
    'CAD': 1.35, // Canada
    'NGN': 1500.0, // Nigeria
    'KES': 145.0, // Kenya
    'THB': 36.0, // Thailand
    'MYR': 4.75, // Malaysia
    'PHP': 56.0, // Philippines
    'IDR': 15700.0, // Indonesia
    'SGD': 1.34, // Singapore
  };

  final Map<String, String> _currencySymbols = {
    'USD': '\$',
    'CNY': '¥',
    'EUR': '€',
    'VND': '₫',
    'CAD': 'CA\$',
    'NGN': '₦',
    'KES': 'KSh',
    'THB': '฿',
    'MYR': 'RM',
    'PHP': '₱',
    'IDR': 'Rp',
    'SGD': 'S\$',
  };

  SettingsProvider() {
    _loadSettings();
  }

  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);
  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbols[_currencyCode] ?? '\$';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('language_code') ?? 'zh';
    _currencyCode = prefs.getString('currency_code') ?? 'CNY';
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

    // Different formatting for currencies with large numbers (VND, IDR)
    int decimalDigits = 2;
    if (['VND', 'IDR', 'KRW', 'JPY'].contains(_currencyCode)) {
      decimalDigits = 0;
    }

    final format = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    return format.format(convertedAmount);
  }
}
