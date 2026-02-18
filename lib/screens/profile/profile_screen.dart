import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../auth/login_screen.dart';
import '../address/address_list_screen.dart';
import '../order/order_list_screen.dart';
import '../settings/settings_screen.dart';
import '../wishlist/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!auth.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.pleaseLoginToViewProfile,
                    style: AppTextStyles.subheading,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(l10n.loginRegister),
                  ),
                ],
              ),
            );
          }

          final user = auth.user!;

          return CustomScrollView(
            slivers: [
              // Header with User Info
              SliverAppBar(
                backgroundColor: AppColors.primary,
                expandedHeight: 140,
                floating: false,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: user.avatar != null
                              ? NetworkImage(user.avatar!)
                              : null,
                          child: user.avatar == null
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.name,
                                style: AppTextStyles.heading.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFFD700),
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      l10n.vipMember,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () {
                            auth.logout();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Order Status Row
              SliverToBoxAdapter(
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                    final unpaidCount = orderProvider.orders
                        .where((o) => o.status == 'Pending')
                        .length;
                    final processingCount = orderProvider.orders
                        .where((o) => o.status == 'Processing')
                        .length;
                    final shippedCount = orderProvider.orders
                        .where((o) => o.status == 'Shipped')
                        .length;
                    final reviewCount = orderProvider.orders
                        .where(
                          (o) => o.status == 'Review',
                        ) // Assuming 'Review' status exists
                        .length;
                    final returnsCount = orderProvider.orders
                        .where(
                          (o) => o.status == 'Returns',
                        ) // Assuming 'Returns' status exists
                        .length;

                    return Container(
                      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.myOrders,
                                style: AppTextStyles.subheading,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OrderListScreen(
                                            initialIndex: 0,
                                          ),
                                    ),
                                  );
                                },
                                child: Text(
                                  '${l10n.viewAll} >',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _OrderStatusItem(
                                icon: FontAwesomeIcons.creditCard,
                                label: l10n.unpaid,
                                badgeCount: unpaidCount,
                                onTap: () => _navigateToOrderList(context, 1),
                              ),
                              _OrderStatusItem(
                                icon: FontAwesomeIcons.boxOpen,
                                label: l10n.processing,
                                badgeCount: processingCount,
                                onTap: () => _navigateToOrderList(context, 2),
                              ),
                              _OrderStatusItem(
                                icon: FontAwesomeIcons.truck,
                                label: l10n.shipped,
                                badgeCount: shippedCount,
                                onTap: () => _navigateToOrderList(context, 3),
                              ),
                              _OrderStatusItem(
                                icon: FontAwesomeIcons.star,
                                label: l10n.review,
                                badgeCount: reviewCount,
                                onTap: () => _navigateToOrderList(context, 4),
                              ),
                              _OrderStatusItem(
                                icon: FontAwesomeIcons.rotateLeft,
                                label: l10n.returns,
                                badgeCount: returnsCount,
                                onTap: () => _navigateToOrderList(context, 5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // My Services Grid
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.myServices, style: AppTextStyles.subheading),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                        children: [
                          _ServiceItem(
                            icon: Icons.message_outlined,
                            label: l10n.messages,
                            color: Colors.blue,
                            onTap: () {},
                          ),
                          _ServiceItem(
                            icon: Icons.confirmation_number_outlined,
                            label: l10n.coupons,
                            color: Colors.orange,
                            onTap: () {},
                          ),
                          _ServiceItem(
                            icon: Icons.favorite_border,
                            label: l10n.wishlist,
                            color: Colors.pink,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WishlistScreen(),
                                ),
                              );
                            },
                          ),
                          _ServiceItem(
                            icon: Icons.account_balance_wallet_outlined,
                            label: l10n.credit,
                            color: Colors.green,
                            onTap: () {},
                          ),
                          _ServiceItem(
                            icon: Icons.location_on_outlined,
                            label: l10n.address,
                            color: Colors.red,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddressListScreen(),
                                ),
                              );
                            },
                          ),
                          _ServiceItem(
                            icon: Icons.history,
                            label: l10n.history,
                            color: Colors.purple,
                            onTap: () {},
                          ),
                          _ServiceItem(
                            icon: Icons.help_outline,
                            label: l10n.support,
                            color: Colors.teal,
                            onTap: () {},
                          ),
                          _ServiceItem(
                            icon: Icons.settings_outlined,
                            label: l10n.settings,
                            color: Colors.grey,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }

  void _navigateToOrderList(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderListScreen(initialIndex: index),
      ),
    );
  }
}

class _OrderStatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int badgeCount;
  final VoidCallback? onTap;

  const _OrderStatusItem({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 24, color: AppColors.textPrimary),
              if (badgeCount > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        badgeCount > 99 ? '99+' : badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
