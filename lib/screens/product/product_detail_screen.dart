import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beikeshop_flutter/screens/product/product_reviews_screen.dart';
import '../../theme/app_theme.dart';
import '../../api/api_service.dart';
import '../../models/models.dart';

import 'package:provider/provider.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../providers/cart_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  Product? _product;
  List<Review> _reviews = [];
  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final product = await ApiService().getProductDetail(widget.productId);
      // Fetch reviews in parallel
      final reviewsResponse = await ApiService().getReviews(widget.productId);
      final List<dynamic> reviewsData = reviewsResponse['data'] ?? [];
      final reviews = reviewsData.map((json) => Review.fromJson(json)).toList();

      if (mounted) {
        setState(() {
          _product = product;
          _reviews = reviews;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');
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
            isFlashSale: true,
            tags: ['Free Shipping', 'Returns Accepted', 'Best Seller'],
          );
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleWishlist() async {
    final wishlistProvider = context.read<WishlistProvider>();
    final isWishlisted = wishlistProvider.isInWishlist(widget.productId);

    try {
      if (isWishlisted) {
        await wishlistProvider.removeFromWishlist(widget.productId);
      } else {
        if (_product != null) {
          await wishlistProvider.addToWishlist(_product!);
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !isWishlisted ? 'Added to wishlist' : 'Removed from wishlist',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update wishlist: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final isWishlisted = wishlistProvider.isInWishlist(widget.productId);
    final l10n = AppLocalizations.of(context)!;

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
        body: Center(child: Text(l10n.productNotFound)),
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
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? Colors.red : Colors.black,
                      ),
                      onPressed: _toggleWishlist,
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
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: _product!.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      if (_product!.isFlashSale)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFB7701), Color(0xFFE02020)],
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.flash_on, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.flashSale,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  l10n.endsIn('02:15:30'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
                            settings.formatPrice(_product!.price),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_product!.originalPrice != null)
                            Text(
                              settings.formatPrice(_product!.originalPrice!),
                              style: const TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textHint,
                              ),
                            ),
                          if (_product!.discountPercentage > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${_product!.discountPercentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
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

                      const SizedBox(height: 8),

                      // Tags
                      if (_product!.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Wrap(
                            spacing: 8,
                            children: _product!.tags
                                .map(
                                  (tag) => Chip(
                                    label: Text(tag),
                                    labelStyle: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: BorderSide(
                                        color: AppColors.primary.withOpacity(
                                          0.2,
                                        ),
                                      ),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )
                                .toList(),
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

                      const Divider(height: 32),

                      // Reviews Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews (${_reviews.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductReviewsScreen(
                                    productId: widget.productId,
                                  ),
                                ),
                              );
                            },
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                      if (_reviews.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'No reviews yet. Be the first to review!',
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _reviews.take(3).length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final review = _reviews[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey[200],
                                      child: const Icon(
                                        Icons.person,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      review.customerName ?? 'Anonymous',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: List.generate(5, (i) {
                                        return Icon(
                                          i < review.rating
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 14,
                                          color: Colors.amber,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(review.comment ?? ''),
                                if (review.images != null &&
                                    review.images!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: SizedBox(
                                      height: 60,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: review.images!.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (context, imgIndex) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  review.images![imgIndex],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              placeholder: (_, __) => Container(
                                                color: Colors.grey[200],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
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
