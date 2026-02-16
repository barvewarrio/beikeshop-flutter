import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import '../../api/api_service.dart';
import '../../models/models.dart';

import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  Product? _product;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final product = await ApiService().getProductDetail(widget.productId);
      if (mounted) {
        setState(() {
          _product = product;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching product details: $e');
      if (mounted) {
        // Fallback to mock data if API fails
        setState(() {
          _product = Product(
            id: widget.productId,
            title: 'Mock Product Details for ${widget.productId}',
            description:
                'This is a detailed description of the product. It features high quality materials, excellent craftsmanship, and durable design. Perfect for daily use.',
            imageUrl:
                'https://picsum.photos/500/500?random=${widget.productId}',
            price: 99.99,
            originalPrice: 129.99,
            sales: 500,
            rating: 4.5,
          );
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // App Bar & Image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: _product!.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),

              // Product Info
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${_product!.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_product!.originalPrice != null)
                            Text(
                              '\$${_product!.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textHint,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Title
                      Text(
                        _product!.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Sales & Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${_product!.sales} sold',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            _product!.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      // Description Title
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description Content
                      Text(
                        _product!.description ?? 'No description available.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      // Space for bottom bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Shop / Chat Icons
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.store, color: AppColors.textSecondary),
                        Text(
                          'Shop',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: AppColors.textSecondary,
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),

                    // Buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_product != null) {
                            context.read<CartProvider>().addToCart(_product!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to cart'),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Buy Now'),
                      ),
                    ),
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
