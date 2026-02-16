import 'package:flutter/material.dart';

class AppColors {
  // Temu/Pinduoduo Style - High Conversion Colors
  static const Color primary = Color(0xFFFB7701); // Temu Orange
  static const Color primaryDark = Color(0xFFE02020); // Hot Red
  static const Color secondary = Color(0xFF1A1A1A); // Deep Black
  
  static const Color background = Color(0xFFF5F5F5); // Light Grey
  static const Color surface = Colors.white;
  
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  
  static const Color success = Color(0xFF25A744);
  static const Color warning = Color(0xFFFF9900);
  static const Color error = Color(0xFFCC0000);
  
  static const Color border = Color(0xFFEEEEEE);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryDark,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );
  
  static const TextStyle originalPrice = TextStyle(
    fontSize: 12,
    color: AppColors.textHint,
    decoration: TextDecoration.lineThrough,
  );
}
