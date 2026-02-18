import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/user_model.dart';
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
      backgroundColor: const Color(0xFFF7F7F7),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!auth.isAuthenticated) {
            return _buildUnauthenticatedView(context, l10n);
          }

          final user = auth.user!;

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, user, auth, l10n),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildOrderCard(context, l10n),
                      const SizedBox(height: 12),
                      _buildServicesCard(context, l10n),
                      const SizedBox(height: 24),
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

  Widget _buildUnauthenticatedView(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_circle_outlined,
              size: 80,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.pleaseLoginToViewProfile,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: 200,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5000), Color(0xFFE02020)],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.loginRegister,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    User user,
    AuthProvider auth,
    AppLocalizations l10n,
  ) {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => auth.logout(),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF5000), Color(0xFFE02020)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.textHint,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD700),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.vipMember,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.myOrders,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const OrderListScreen(initialIndex: 0),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      l10n.viewAll,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Consumer<OrderProvider>(
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
                  .where((o) => o.status == 'Review')
                  .length;
              final returnsCount = orderProvider.orders
                  .where((o) => o.status == 'Returns')
                  .length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _OrderStatusItem(
                      icon: FontAwesomeIcons.wallet,
                      label: l10n.unpaid,
                      badgeCount: unpaidCount,
                      onTap: () => _navigateToOrderList(context, 1),
                    ),
                  ),
                  Expanded(
                    child: _OrderStatusItem(
                      icon: FontAwesomeIcons.box,
                      label: l10n.processing,
                      badgeCount: processingCount,
                      onTap: () => _navigateToOrderList(context, 2),
                    ),
                  ),
                  Expanded(
                    child: _OrderStatusItem(
                      icon: FontAwesomeIcons.truckFast,
                      label: l10n.shipped,
                      badgeCount: shippedCount,
                      onTap: () => _navigateToOrderList(context, 3),
                    ),
                  ),
                  Expanded(
                    child: _OrderStatusItem(
                      icon: FontAwesomeIcons.penToSquare,
                      label: l10n.review,
                      badgeCount: reviewCount,
                      onTap: () => _navigateToOrderList(context, 4),
                    ),
                  ),
                  Expanded(
                    child: _OrderStatusItem(
                      icon: FontAwesomeIcons.rotateLeft,
                      label: l10n.returns,
                      badgeCount: returnsCount,
                      onTap: () => _navigateToOrderList(context, 5),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myServices,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 24,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: [
              _ServiceItem(
                icon: FontAwesomeIcons.envelope,
                label: l10n.messages,
                color: Colors.blue,
                onTap: () {},
              ),
              _ServiceItem(
                icon: FontAwesomeIcons.ticket,
                label: l10n.coupons,
                color: Colors.orange,
                onTap: () {},
              ),
              _ServiceItem(
                icon: FontAwesomeIcons.heart,
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
                icon: FontAwesomeIcons.wallet,
                label: l10n.credit,
                color: Colors.green,
                onTap: () {},
              ),
              _ServiceItem(
                icon: FontAwesomeIcons.locationDot,
                label: l10n.address,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddressListScreen(),
                    ),
                  );
                },
              ),
              _ServiceItem(
                icon: FontAwesomeIcons.clockRotateLeft,
                label: l10n.history,
                color: Colors.purple,
                onTap: () {},
              ),
              _ServiceItem(
                icon: FontAwesomeIcons.headset,
                label: l10n.support,
                color: Colors.teal,
                onTap: () {},
              ),
              _ServiceItem(
                icon: FontAwesomeIcons.gear,
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
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 24, color: AppColors.textPrimary),
                if (badgeCount > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
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
                            height: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
