import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../widgets/home_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/promotional_banner.dart';
import '../category/category_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';
import '../product/product_detail_screen.dart';
import '../../api/api_service.dart';
import '../../models/models.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Product> _products = [];
  List<Category> _categories = [];
  Timer? _timer;
  Duration _timeLeft = const Duration(hours: 2, minutes: 15, seconds: 30);

  // Mock Data for now until API is fully ready
  final List<String> _bannerImages = [
    'https://img.freepik.com/free-vector/flat-horizontal-banner-template-black-friday-sales_23-2150867247.jpg',
    'https://img.freepik.com/free-vector/gradient-flash-sale-background_23-2149027975.jpg',
    'https://img.freepik.com/free-psd/horizontal-banner-online-fashion-sale_23-2148585444.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
    _fetchData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft.inSeconds > 0) {
            _timeLeft -= const Duration(seconds: 1);
          } else {
            // Reset for demo
            _timeLeft = const Duration(hours: 4);
          }
        });
      }
    });
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        ApiService().getLatestProducts(limit: 20),
        ApiService().getCategories(),
      ]);

      if (mounted) {
        setState(() {
          _products = results[0] as List<Product>;
          _categories = results[1] as List<Category>;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
      }
    }
  }

  // void _generateMockCategories() {
  //   final names = [
  //     'Women',
  //     'Men',
  //     'Home',
  //     'Electronics',
  //     'Beauty',
  //     'Shoes',
  //     'Bags',
  //     'Kids',
  //   ];
  //   _categories = List.generate(
  //     names.length,
  //     (index) => Category(id: index.toString(), name: names[index]),
  //   );
  // }

  // void _generateMockProducts() {
  //   _products = List.generate(20, (index) {
  //     final isFlash = index % 3 == 0;
  //     final original = 20 + index * 3.0;
  //     final price = isFlash ? original * 0.5 : original * 0.8;
  //     return Product(
  //       id: index.toString(),
  //       title:
  //           'High Quality Wireless Headphones with Noise Cancellation $index',
  //       imageUrl: 'https://picsum.photos/300/300?random=$index',
  //       price: price,
  //       originalPrice: original,
  //       sales: 100 + index * 10,
  //       isFlashSale: isFlash,
  //       tags: index % 2 == 0 ? ['Free Shipping', 'Low Stock'] : ['Best Seller'],
  //     );
  //   });
  // }

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildFlashSaleSection() {
    final l10n = AppLocalizations.of(context)!;
    final flashSaleProducts = _products
        .where((p) => p.isFlashSale)
        .take(5)
        .toList();
    if (flashSaleProducts.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_timeLeft.inHours);
    final minutes = twoDigits(_timeLeft.inMinutes.remainder(60));
    final seconds = twoDigits(_timeLeft.inSeconds.remainder(60));

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.primary, size: 24),
                  const SizedBox(width: 4),
                  Text(
                    l10n.flashSale,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildTimerBox(hours),
                  _buildTimerSeparator(),
                  _buildTimerBox(minutes),
                  _buildTimerSeparator(),
                  _buildTimerBox(seconds),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          l10n.viewAll,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                scrollDirection: Axis.horizontal,
                itemCount: flashSaleProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = flashSaleProducts[index];
                  return Consumer<SettingsProvider>(
                    builder: (context, settings, _) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                      placeholder: (context, url) =>
                                          Container(color: Colors.grey[200]),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF5000),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      child: Text(
                                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      settings.formatPrice(product.price),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 14,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              7,
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: 0.7, // Mock progress
                                          child: Container(
                                            height: 14,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFF5000),
                                                  Color(0xFFFF8C00),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '${product.sales} ${l10n.sold}',
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 2,
                                                  color: Colors.black26,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTimerSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildHomeBody() {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Banner Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: PromotionalBanner(imageUrls: _bannerImages),
            ),
          ),

          // Category Icons (Horizontal Scroll)
          if (_categories.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to category
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              shape: BoxShape.circle,
                              image: category.imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(category.imageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: category.imageUrl == null
                                ? const Icon(Icons.category, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 70,
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF333333),
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

          // Flash Sale Section
          _buildFlashSaleSection(),

          // Recommended Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.recommend,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.recommendedForYou,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          l10n.seeAll,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Waterfall Product Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine which body to show based on selected index
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = _buildHomeBody();
        break;
      case 1:
        body = const CategoryScreen();
        break;
      case 2:
        body = const ProfileScreen();
        break;
      case 3:
        body = const CartScreen();
        break;
      default:
        body = _buildHomeBody();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _currentIndex == 0
          ? const HomeAppBar()
          : null, // Only show custom AppBar on Home
      body: body,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
