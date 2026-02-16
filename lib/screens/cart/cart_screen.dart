import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import '../../providers/cart_provider.dart';

import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Text(
              'Shopping Cart (${cart.itemCount})',
              style: AppTextStyles.heading,
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to home (assuming this is managed by parent)
                      // Or just switch tab if possible, but here we can't easily switch tab index without callback
                      // Just popping if pushed, but it's a tab...
                      // For now user can click bottom nav
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Free Shipping Progress
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: const Color(0xFFFFF7E6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'Add '),
                            TextSpan(
                              text: '\$15.00',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(text: ' more for free shipping'),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ),

              // Cart Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Checkbox
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: item.isSelected,
                              onChanged: (v) {
                                cart.toggleSelection(item.product.id);
                              },
                              activeColor: AppColors.primary,
                              shape: const CircleBorder(),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: item.product.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Quantity Control
                                Row(
                                  children: [
                                    _buildQtyBtn(Icons.remove, () {
                                      cart.updateQuantity(
                                        item.product.id,
                                        item.quantity - 1,
                                      );
                                    }),
                                    Container(
                                      width: 40,
                                      alignment: Alignment.center,
                                      child: Text('${item.quantity}'),
                                    ),
                                    _buildQtyBtn(Icons.add, () {
                                      cart.updateQuantity(
                                        item.product.id,
                                        item.quantity + 1,
                                      );
                                    }),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: AppColors.textHint,
                                      ),
                                      onPressed: () {
                                        cart.removeFromCart(item.product.id);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Checkout Bar
              Container(
                padding: const EdgeInsets.all(16),
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
                      Row(
                        children: [
                          Checkbox(
                            value:
                                cart.items.isNotEmpty &&
                                cart.items.every((i) => i.isSelected),
                            onChanged: cart.items.isEmpty
                                ? null
                                : (v) {
                                    cart.toggleAll(v ?? false);
                                  },
                            activeColor: AppColors.primary,
                            shape: const CircleBorder(),
                          ),
                          const Text(
                            'All',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: cart.selectedCount > 0
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckoutScreen(),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text('Checkout (${cart.selectedCount})'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14, color: AppColors.textSecondary),
      ),
    );
  }
}
