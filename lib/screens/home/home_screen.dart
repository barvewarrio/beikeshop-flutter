import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../widgets/home_app_bar.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/promotional_banner.dart';
import '../../widgets/age_verification_modal.dart';
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

  // Mock Data for now until API is fully ready
  final List<String> _bannerImages = [
    'https://img.freepik.com/free-vector/flat-horizontal-banner-template-black-friday-sales_23-2150867247.jpg',
    'https://img.freepik.com/free-vector/gradient-flash-sale-background_23-2149027975.jpg',
    'https://img.freepik.com/free-psd/horizontal-banner-online-fashion-sale_23-2148585444.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AgeVerificationModal.checkAndShow(context);
      }
    });
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        ApiService().getProducts(),
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
      print('Error fetching data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Use fallback mock data if API fails (e.g. server offline)
          if (_products.isEmpty) _generateMockProducts();
        });
      }
    }
  }

  void _generateMockProducts() {
    _products = List.generate(20, (index) {
      final isFlash = index % 3 == 0;
      final original = 20 + index * 3.0;
      final price = isFlash ? original * 0.5 : original * 0.8;
      return Product(
        id: index.toString(),
        title:
            'High Quality Wireless Headphones with Noise Cancellation $index',
        imageUrl: 'https://picsum.photos/300/300?random=$index',
        price: price,
        originalPrice: original,
        sales: 100 + index * 10,
        isFlashSale: isFlash,
        tags: index % 2 == 0 ? ['Free Shipping', 'Low Stock'] : ['Best Seller'],
      );
    });
  }

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
    if (flashSaleProducts.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.flash_on,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.flashSale,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '02:15:30',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${l10n.viewAll} >',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                        child: SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        fit: BoxFit.cover,
                                        width: 100,
                                        height: 100,
                                        placeholder: (context, url) =>
                                            Container(color: Colors.grey[200]),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: AppColors.primary.withOpacity(
                                          0.8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          '-${product.discountPercentage.toStringAsFixed(0)}%',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                settings.formatPrice(product.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                settings.formatPrice(
                                  product.originalPrice ?? 0,
                                ),
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 10,
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
            const SizedBox(height: 12),
          ],
        ),
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
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 60,
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
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
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.recommendedForYou, style: AppTextStyles.heading),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '${l10n.seeAll} >',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Waterfall Product Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCard(
                  title: product.title,
                  imageUrl: product.imageUrl,
                  price: product.price,
                  originalPrice: product.originalPrice,
                  sales: '${product.sales} ${l10n.sold}',
                  isFlashSale: product.isFlashSale,
                  discountPercentage: product.discountPercentage,
                  tags: product.tags,
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
