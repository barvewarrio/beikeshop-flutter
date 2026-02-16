import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/home/home_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/address_provider.dart';
import 'providers/order_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeikeShop Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily:
            'Roboto', // Default fallback, Google Fonts can be added later
      ),
      home: const HomeScreen(),
    );
  }
}
