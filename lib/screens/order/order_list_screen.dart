import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/order_model.dart';
import 'order_detail_screen.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Define tabs and their corresponding status filter
    final tabs = [
      {'label': l10n.all, 'status': null},
      {
        'label': l10n.unpaid,
        'status': 'Pending',
      }, // Assuming 'Pending' means Unpaid
      {'label': l10n.processing, 'status': 'Processing'},
      {'label': l10n.shipped, 'status': 'Shipped'},
      {'label': l10n.review, 'status': 'Review'},
      {'label': l10n.returns, 'status': 'Returns'},
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.myOrders),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: tabs.map((t) => Tab(text: t['label'] as String)).toList(),
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            if (orderProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              children: tabs.map((tab) {
                final status = tab['status'] as String?;
                final orders = status == null
                    ? orderProvider.orders
                    : orderProvider.orders.where((o) {
                        if (status == 'Review' && o.status == 'Delivered') {
                          return true;
                        }
                        return o.status == status;
                      }).toList();

                if (orders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.cartEmpty, // Reuse empty cart message or add specific one
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _OrderCard(order: orders[index]);
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  String _getStatusText(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status) {
      case 'Pending':
        return l10n.statusPending;
      case 'Processing':
        return l10n.statusProcessing;
      case 'Shipped':
        return l10n.statusShipped;
      case 'Delivered':
        return l10n.statusDelivered;
      case 'Cancelled':
        return l10n.statusCancelled;
      case 'Review':
        return l10n.review;
      case 'Returns':
        return l10n.returns;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    // Calculate total items count
    final totalItems = order.items.fold(0, (sum, item) => sum + item.quantity);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Shop Name + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Ensure you have a logo asset or use an icon
                      width: 20,
                      height: 20,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.store,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'BeikeShop Official',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
                Text(
                  _getStatusText(context, order.status),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Product Thumbnails or Single Item
            if (order.items.length == 1)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: order.items[0].product.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[100]),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.items[0].product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${settings.formatPrice(order.items[0].product.price)} x${order.items[0].quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: order.items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.product.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[100]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Total & Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  '${l10n.itemCount(totalItems)} ${l10n.total}: ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Expanded(
                  child: Text(
                    settings.formatPrice(order.totalAmount),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == 'Delivered') ...[
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      l10n.review,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                if (order.status == 'Pending') ...[
                  OutlinedButton(
                     onPressed: () {},
                     style: OutlinedButton.styleFrom(
                       foregroundColor: AppColors.textPrimary,
                       side: const BorderSide(color: AppColors.border),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                       padding: const EdgeInsets.symmetric(horizontal: 16),
                       minimumSize: const Size(0, 36),
                     ),
                     child: Text(
                       l10n.cancelOrder,
                       style: const TextStyle(fontSize: 14),
                     ),
                   ),
                   const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      l10n.payNow,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ] else
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      l10n.buyAgain,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
