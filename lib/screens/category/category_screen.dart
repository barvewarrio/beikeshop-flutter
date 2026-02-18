import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../api/api_service.dart';
import '../../models/models.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../widgets/product_card.dart';

import '../product/product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  List<Category> _categories = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _generateMockProducts();
  }

  void _generateMockProducts() {
    _products = List.generate(10, (index) {
      final original = 20 + index * 3.0;
      return Product(
        id: 'cat_prod_${_selectedIndex}_$index',
        title: 'Category ${_selectedIndex + 1} Item $index',
        imageUrl:
            'https://picsum.photos/300/300?random=${_selectedIndex * 100 + index}',
        price: original * 0.8,
        originalPrice: original,
        sales: 50 + index * 5,
      );
    });
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final categories = await ApiService().getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _generateMockCategories();
        });
      }
    }
  }

  void _generateMockCategories() {
    final names = [
      'Recommended',
      'Women',
      'Men',
      'Home',
      'Electronics',
      'Beauty',
      'Shoes',
      'Bags',
      'Kids',
      'Sports',
      'Automotive',
      'Pets',
    ];
    _categories = List.generate(
      names.length,
      (index) => Category(id: index.toString(), name: names[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!, width: 0.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black54, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.searchCategories,
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.camera_alt_outlined, color: Colors.black54, size: 22),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline, color: Colors.black87, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar (Category List)
          Container(
            width: 90,
            color: Colors.grey[100],
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                final category = _categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _generateMockProducts();
                    });
                  },
                  child: Container(
                    height: 50,
                    color: isSelected ? Colors.white : const Color(0xFFF5F5F5),
                    child: Stack(
                      children: [
                        if (isSelected)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 4,
                              color: AppColors.primary,
                            ),
                          ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              category.name,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFF555555),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Right Content (Subcategories Grid)
          Expanded(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    // Banner for Category
                    SliverToBoxAdapter(
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://picsum.photos/400/150?random=$_selectedIndex',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            l10n.topPicksIn(
                              _categories.isNotEmpty
                                  ? _categories[_selectedIndex].name
                                  : "",
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Subcategories Grid
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to subcategory
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFF5F5F5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://picsum.photos/100/100?random=${_selectedIndex * 100 + index}',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Container(color: Colors.grey[200]),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Subcat $index',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }, childCount: 9),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Recommended Title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          l10n.recommendedForYou,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    // Product Grid (Waterfall)
                    SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childCount: _products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: _products[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  productId: _products[index].id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
