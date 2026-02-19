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
        if (_categories.isNotEmpty) {
          _fetchCategoryProducts(_categories[0].id);
        }
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load categories: $e')),
        );
      }
    }
  }

  Future<void> _fetchCategoryProducts(String categoryId) async {
    // Only show loading for products if needed, or keep previous products
    try {
      final products = await ApiService().getProducts(categoryId: categoryId);
      if (mounted) {
        setState(() {
          _products = products;
        });
      }
    } catch (e) {
      debugPrint('Error fetching products for category $categoryId: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load products: $e')));
      }
    }
  }

  void _onSearchTap() {
    // Navigate to search screen or show search dialog
    // For now, just print
    debugPrint('Navigate to search');
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
          child: GestureDetector(
            onTap: _onSearchTap,
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
                const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black54,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.mail_outline,
              color: Colors.black87,
              size: 26,
            ),
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
                    });
                    _fetchCategoryProducts(category.id);
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
                    if (_categories.isNotEmpty &&
                        _categories[_selectedIndex].imageUrl != null)
                      SliverToBoxAdapter(
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(
                                _categories[_selectedIndex].imageUrl!,
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
                    if (_categories.isNotEmpty &&
                        _categories[_selectedIndex].children.isNotEmpty)
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.8,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final subCategory =
                                _categories[_selectedIndex].children[index];
                            return GestureDetector(
                              onTap: () {
                                _fetchCategoryProducts(subCategory.id);
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
                                        child: subCategory.imageUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: subCategory.imageUrl!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                          Icons.category,
                                                          color: Colors.grey,
                                                        ),
                                              )
                                            : const Center(
                                                child: Icon(
                                                  Icons.category,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    subCategory.name,
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
                          },
                          childCount:
                              _categories[_selectedIndex].children.length,
                        ),
                      ),

                    if (_categories.isNotEmpty &&
                        _categories[_selectedIndex].children.isNotEmpty)
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
