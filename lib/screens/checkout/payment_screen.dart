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
  bool _isLoading = false;

  Future<void> _processPayment() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      final result = await context.read<OrderProvider>().payOrder(
        widget.order.id,
        widget.order.paymentMethod,
      );

      // Handle Stripe
      if (widget.order.paymentMethod == 'stripe') {
         if (result['client_secret'] != null) {
            // Mock Stripe success for now
            ScaffoldMessenger.of(context).showSnackBar(
               const SnackBar(content: Text('Stripe payment simulated successfully')),
            );
         }
      }

      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(l10n.orderPlaced)),
        );
         Navigator.of(context).pushAndRemoveUntil(
           MaterialPageRoute(
             builder: (context) => OrderDetailScreen(order: widget.order),
           ),
           (route) => route.isFirst,
         );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
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
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.payNow)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.total,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              settings.formatPrice(widget.order.totalAmount),
               style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 30),
             Text(
              '${l10n.paymentMethod}: ${widget.order.paymentMethod}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _isLoading ? null : _processPayment,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(l10n.payNow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
