import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';
import '../../theme/app_theme.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<WishlistProvider>(context, listen: false).fetchWishlist(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wishlistProvider.error != null) {
            return Center(child: Text('Error: ${wishlistProvider.error}'));
          }

          if (wishlistProvider.wishlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: AppTextStyles.heading.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: wishlistProvider.wishlist.length,
            itemBuilder: (context, index) {
              final product = wishlistProvider.wishlist[index];
              return Stack(
                children: [
                  ProductCard(
                    title: product.title,
                    imageUrl: product.imageUrl,
                    price: product.price,
                    originalPrice: product.originalPrice,
                    sales: '${product.sales} sold',
                    isFlashSale: product.isFlashSale,
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
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
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
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          // Show confirmation dialog? Or just remove.
                          // For better UX, maybe just remove with undo snackbar.
                          // But for now, let's just remove.
                          wishlistProvider.removeFromWishlist(product.id);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
