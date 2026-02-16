import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/address_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/address_model.dart';
import '../../theme/app_theme.dart';
import '../address/address_list_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  bool _isLoading = false;
  String _paymentMethod = 'Credit Card';

  @override
  void initState() {
    super.initState();
    // Pre-select default address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressProvider = context.read<AddressProvider>();
      setState(() {
        _selectedAddress = addressProvider.defaultAddress;
      });
    });
  }

  void _selectAddress() async {
    // Navigate to address list and wait for selection
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressListScreen()),
    );

    // If user returns, we should refresh the selected address
    // In a real app, we might pass the selected address back
    if (mounted) {
      final addressProvider = context.read<AddressProvider>();
      setState(() {
        // If we had an address, try to keep it (if it still exists), otherwise use default
        if (_selectedAddress != null) {
          try {
            _selectedAddress = addressProvider.addresses.firstWhere(
              (a) => a.id == _selectedAddress!.id,
            );
          } catch (e) {
            _selectedAddress = addressProvider.defaultAddress;
          }
        } else {
          _selectedAddress = addressProvider.defaultAddress;
        }
      });
    }
  }

  void _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a shipping address')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final cart = context.read<CartProvider>();
      final selectedItems = cart.items
          .where((item) => item.isSelected)
          .toList();
      final total = cart.totalAmount;

      if (selectedItems.isEmpty) {
        throw Exception('No items selected');
      }

      // Create Order
      await context.read<OrderProvider>().placeOrder(
        selectedItems,
        total,
        _selectedAddress!,
        _paymentMethod,
      );

      // Clear purchased items from cart
      for (var item in selectedItems) {
        cart.removeFromCart(item.product.id);
      }

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Order Placed!'),
            content: const Text('Your order has been successfully placed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // Close dialog
                  Navigator.pop(context); // Close checkout
                  // Ideally navigate to Order List or Home
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error placing order: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final settings = context.watch<SettingsProvider>();
    final selectedItems = cart.items.where((item) => item.isSelected).toList();

    if (selectedItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('No items to checkout')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Address Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shipping Address',
                                style: AppTextStyles.subheading,
                              ),
                              TextButton(
                                onPressed: _selectAddress,
                                child: Text(
                                  _selectedAddress == null ? 'Add' : 'Change',
                                ),
                              ),
                            ],
                          ),
                          if (_selectedAddress != null) ...[
                            Text(
                              _selectedAddress!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(_selectedAddress!.phone),
                            const SizedBox(height: 4),
                            Text(
                              '${_selectedAddress!.addressLine}, ${_selectedAddress!.city}, ${_selectedAddress!.province}, ${_selectedAddress!.country}',
                            ),
                          ] else
                            const Text(
                              'No address selected',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Items Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Items',
                            style: AppTextStyles.subheading,
                          ),
                          const SizedBox(height: 8),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: selectedItems.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final item = selectedItems[index];
                              return Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          item.product.imageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'x${item.quantity}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(settings.formatPrice(item.totalPrice)),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Method
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Method',
                            style: AppTextStyles.subheading,
                          ),
                          const SizedBox(height: 8),
                          RadioListTile<String>(
                            title: const Text('Credit Card'),
                            value: 'Credit Card',
                            groupValue: _paymentMethod,
                            onChanged: (value) =>
                                setState(() => _paymentMethod = value!),
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                          ),
                          RadioListTile<String>(
                            title: const Text('PayPal'),
                            value: 'PayPal',
                            groupValue: _paymentMethod,
                            onChanged: (value) =>
                                setState(() => _paymentMethod = value!),
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                          ),
                          RadioListTile<String>(
                            title: const Text('Cash on Delivery (COD)'),
                            value: 'COD',
                            groupValue: _paymentMethod,
                            onChanged: (value) =>
                                setState(() => _paymentMethod = value!),
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _SummaryRow(
                            label: 'Subtotal',
                            value: settings.formatPrice(cart.totalAmount),
                          ),
                          _SummaryRow(
                            label: 'Shipping',
                            value: settings.formatPrice(0.0),
                          ), // Free shipping for now
                          const Divider(),
                          _SummaryRow(
                            label: 'Total',
                            value: settings.formatPrice(cart.totalAmount),
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Place Order Button
                  ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
