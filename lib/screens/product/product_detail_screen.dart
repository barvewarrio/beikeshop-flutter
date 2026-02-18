import 'dart:async';
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
  late Timer _timer;
  int _timeLeft = 8130; // 02:15:30 in seconds

  @override
  void initState() {
    super.initState();
    _startTimer();
    _fetchProductDetails();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _timeLeft--;
          });
        }
      }
    });
  }

  String get _timerString {
    final hours = (_timeLeft / 3600).floor();
    final minutes = ((_timeLeft % 3600) / 60).floor();
    final seconds = _timeLeft % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
    final l10n = AppLocalizations.of(context)!;

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
              !isWishlisted ? l10n.addedToWishlist : l10n.removedFromWishlist,
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToUpdateWishlist(e.toString()))),
        );
      }
    }
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B8D1F), size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF1B8D1F),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
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
                                  l10n.endsIn(_timerString),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
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
                                        .withValues(alpha: 0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: BorderSide(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
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
                              l10n.soldCount(_product!.sales.toString()),
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
                          // Low Stock Warning (Mock logic: ID ends with odd number)
                          if (int.tryParse(
                                    _product!.id.substring(
                                      _product!.id.length - 1,
                                    ),
                                  ) !=
                                  null &&
                              int.parse(
                                        _product!.id.substring(
                                          _product!.id.length - 1,
                                        ),
                                      ) %
                                      2 !=
                                  0)
                            Container(
                              margin: const EdgeInsets.only(left: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.lowStock(5), // Mock low stock count
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Delivery & Returns
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_shipping_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.freeShipping,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.deliveryBy(
                                      'Oct 25 - Oct 28',
                                    ), // Mock date
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(height: 1),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.verified_user_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    l10n.freeReturns,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      // Trust Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTrustBadge(
                            Icons.lock_outline,
                            l10n.securePayment,
                          ),
                          _buildTrustBadge(
                            Icons.verified_user_outlined,
                            l10n.buyerProtection,
                          ),
                          _buildTrustBadge(
                            Icons.local_shipping_outlined,
                            l10n.deliveryGuarantee,
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      // Description Title
                      Text(
                        l10n.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description Content
                      Text(
                        _product!.description ?? l10n.noResults, // Fallback
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
                            l10n.reviewsTitle(_reviews.length),
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
                            child: Text(l10n.seeAll),
                          ),
                        ],
                      ),
                      if (_reviews.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(l10n.noReviewsYet),
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
                                      review.customerName,
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
                                if (review.images.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: SizedBox(
                                      height: 60,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: review.images.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(width: 8),
                                        itemBuilder: (context, imgIndex) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: review.images[imgIndex],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                    color: Colors.grey[200],
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
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
                    ],
                  ),
                ),
              ),
              // Add bottom padding for the fixed bottom bar
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          // Navigate to cart
                          // Use root navigator or just push
                          // For now maybe just show cart or go back if coming from cart?
                          // Let's assume standard nav to cart
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_product != null) {
                            context.read<CartProvider>().addToCart(
                              _product!,
                              quantity: 1,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.addedToCart),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.addToCart,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_product != null) {
                            // Add to cart then go to checkout
                            context.read<CartProvider>().addToCart(
                              _product!,
                              quantity: 1,
                            );
                            // Navigate to checkout (which usually requires cart)
                            // For now, just navigate to cart or checkout screen
                            Navigator.pushNamed(context, '/checkout');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.buyNow,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
