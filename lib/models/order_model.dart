import '../providers/cart_provider.dart';
import 'address_model.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final Address shippingAddress;
  final DateTime date;
  final String
  status; // 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
  final String paymentMethod; // 'Credit Card', 'PayPal', 'COD'

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.date,
    this.status = 'Pending',
    required this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      shippingAddress: Address.fromJson(json['shippingAddress']),
      date: DateTime.parse(json['date']),
      status: json['status'],
      paymentMethod: json['paymentMethod'] ?? 'Credit Card',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toJson(),
      'date': date.toIso8601String(),
      'status': status,
      'paymentMethod': paymentMethod,
    };
  }
}
