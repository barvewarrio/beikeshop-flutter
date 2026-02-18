import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/settings_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/cart_provider.dart';
import '../models/models.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final wishlistProvider = context.watch<WishlistProvider>();
    final isInWishlist = wishlistProvider.isInWishlist(product.id);
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Flash Sale Badge and Wishlist Button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (product.isFlashSale)
                  Positioned(
                    top: 8,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Flash Sale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        if (isInWishlist) {
                          wishlistProvider.removeFromWishlist(product.id);
                        } else {
                          wishlistProvider.addToWishlist(product);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(height: 1.2),
                  ),
                  const SizedBox(height: 4),

                  // Tags
                  if (product.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Wrap(
                        spacing: 4,
                        children: product.tags
                            .take(2)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        settings.formatPrice(product.price),
                        style: AppTextStyles.price.copyWith(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      if (product.originalPrice != null)
                        Text(
                          settings.formatPrice(product.originalPrice!),
                          style: AppTextStyles.originalPrice.copyWith(
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),

                  if (product.discountPercentage > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFF5000,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${product.discountPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFFFF5000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (product.sales > 0 && l10n != null)
                            Text(
                              l10n.soldCount(product.sales.toString()),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),
                  // Add to Cart Button (Small)
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await context.read<CartProvider>().addToCart(product);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.title} added to cart'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error adding to cart: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                      ),
                      child: Text(
                        l10n?.cart ?? 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
