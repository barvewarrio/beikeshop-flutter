import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/settings_provider.dart';
import '../order/order_detail_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Order order;

  const PaymentScreen({super.key, required this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Order _order;
  bool _isLoading = false;
  late Timer _timer;
  int _timeLeft = 900; // 15 minutes in seconds

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _startTimer();
    _refreshOrder();
  }

  Future<void> _refreshOrder() async {
    try {
      final updatedOrder = await context.read<OrderProvider>().getOrder(
        widget.order.id,
      );
      if (mounted) {
        setState(() {
          _order = updatedOrder;
        });
      }
    } catch (e) {
      debugPrint('Error refreshing order: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  String get _timerString {
    final minutes = (_timeLeft / 60).floor();
    final seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _processPayment() async {
    final l10n = AppLocalizations.of(context)!;

    // Check if already paid
    if (_order.status.toLowerCase() == 'processing' ||
        _order.status.toLowerCase() == 'completed' ||
        _order.status.toLowerCase() == 'paid') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.orderAlreadyPaid)));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => OrderDetailScreen(order: _order),
        ),
        (route) => route.isFirst,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final code = _order.paymentMethodCode.isNotEmpty
          ? _order.paymentMethodCode
          : 'cod';

      final result = await context.read<OrderProvider>().payOrder(
        _order.id,
        code,
      );

      // Handle Stripe
      if (code == 'stripe' ||
          _order.paymentMethod.toLowerCase().contains('stripe')) {
        if (result['client_secret'] != null) {
          // Mock Stripe success for now
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Stripe payment simulated successfully'),
              ),
            );
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.paymentSuccess)),
        ); // Changed from orderPlaced

        // Refresh order to get updated status
        await _refreshOrder();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => OrderDetailScreen(order: _order),
            ),
            (route) => route.isFirst,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final formattedPrice = settings.formatPrice(_order.totalAmount);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 20),
            const SizedBox(width: 8),
            Text(
              l10n.secureCheckout,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          // Timer Banner (Temu Style)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFFFF1F0), // Light red/pink background
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Order reserved for ',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _timerString,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Total Amount Card
                  Container(
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
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          l10n.total,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedPrice,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Payment Method
                  Container(
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
                        Text(
                          l10n.paymentMethod,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primary.withValues(alpha: 0.05),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: Icon(
                              _order.paymentMethod == 'stripe'
                                  ? Icons.credit_card
                                  : _order.paymentMethod == 'paypal'
                                  ? Icons.paypal
                                  : Icons.money,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            title: Text(
                              _order.paymentMethod.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              l10n.securePayment,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Order Summary
                  Container(
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
                        Text(
                          l10n.orderSummary,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          l10n.orderId,
                          '#${_order.number}',
                          isBold: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1),
                        ),
                        _buildInfoRow(
                          l10n.items,
                          '${_order.items.length}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Trust Badges (Temu Style)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTrustBadge(Icons.security, l10n.securePayment),
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
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Bottom Pay Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5000), Color(0xFFE02020)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _processPayment,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          '${l10n.payNow} $formattedPrice',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1B8D1F), size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1B8D1F),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
