import 'package:flutter/material.dart';
import 'package:beikeshop_flutter/api/api_service.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import 'package:beikeshop_flutter/models/models.dart';
import 'package:beikeshop_flutter/models/order_model.dart';
import 'package:beikeshop_flutter/theme/app_theme.dart';

class RequestRefundScreen extends StatefulWidget {
  final Order order;
  final CartItem item;

  const RequestRefundScreen({Key? key, required this.order, required this.item})
    : super(key: key);

  @override
  State<RequestRefundScreen> createState() => _RequestRefundScreenState();
}

class _RequestRefundScreenState extends State<RequestRefundScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  List<RmaReason> _reasons = [];
  String? _selectedReasonId;
  int _quantity = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchReasons();
  }

  Future<void> _fetchReasons() async {
    try {
      final reasons = await ApiService().getRmaReasons();
      if (mounted) {
        setState(() {
          _reasons = reasons;
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error fetching RMA reasons: $e');
    }
  }

  Future<void> _submitRefund() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedReasonId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectReason)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService().createRma({
        'order_id': widget.order.id,
        'order_product_id':
            widget.item.id, // This is mapped to order_product_id
        'quantity': _quantity,
        'reason_id': _selectedReasonId,
        'comment': _commentController.text,
        'type': 'refund', // or 'replace'
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.submitSuccess)));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.requestRefund),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.item.product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
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
                                  widget.item.product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'x${widget.item.quantity}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Reason Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedReasonId,
                      decoration: InputDecoration(
                        labelText: l10n.rmaReason,
                        border: const OutlineInputBorder(),
                      ),
                      items: _reasons.map((reason) {
                        return DropdownMenuItem(
                          value: reason.id,
                          child: Text(reason.name),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedReasonId = value),
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    TextFormField(
                      initialValue: _quantity.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Quantity', // Add to l10n if needed
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          _quantity = int.tryParse(value) ?? 1,
                      validator: (value) {
                        final val = int.tryParse(value ?? '');
                        if (val == null || val < 1) return 'Invalid quantity';
                        if (val > widget.item.quantity)
                          return 'Exceeds purchased quantity';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Comment
                    TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitRefund,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(l10n.submit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
