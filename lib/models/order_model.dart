import '../models/models.dart';
import 'address_model.dart';

class Order {
  final String id;
  final String number;
  final List<CartItem> items;
  final double totalAmount;
  final Address shippingAddress;
  final DateTime date;
  final String
  status; // 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'
  final String paymentMethod; // 'Credit Card', 'PayPal', 'COD'
  final List<OrderShipment> shipments;

  Order({
    required this.id,
    required this.number,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.date,
    this.status = 'Pending',
    required this.paymentMethod,
    this.shipments = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Handle items
    List<CartItem> items = [];
    if (json['order_products'] != null) {
      items = (json['order_products'] as List).map((item) {
        // Backend order product structure
        // 'product_id', 'name', 'price', 'quantity', 'image' (maybe), 'product_sku'
        // Need to adapt to CartItem.fromBackendJson expects
        // But CartItem.fromBackendJson expects 'image_url'.
        // OrderProduct has 'image'.
        Map<String, dynamic> itemJson = Map.from(item);
        itemJson['image_url'] = item['image'];
        // Also ensure 'selected' is true
        itemJson['selected'] = true;
        // Map order_product_id to cart_id so CartItem picks it up as 'id'
        itemJson['cart_id'] = item['id'];
        return CartItem.fromBackendJson(itemJson);
      }).toList();
    } else if (json['items'] != null) {
      // Fallback for mock data structure
      items = (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
    }

    // Handle address
    Address address;
    if (json['shippingAddress'] != null) {
      address = Address.fromJson(json['shippingAddress']);
    } else {
      // Construct from flattened fields
      address = Address(
        id: '', // Not provided in flattened structure
        name: json['shipping_customer_name'] ?? json['customer_name'] ?? '',
        phone: json['shipping_telephone'] ?? json['telephone'] ?? '',
        country: json['shipping_country'] ?? '',
        province: json['shipping_zone'] ?? '',
        city: json['shipping_city'] ?? '',
        addressLine: json['shipping_address_1'] ?? '',
        zipCode: json['shipping_zipcode'] ?? '',
      );
    }

    // Handle shipments
    List<OrderShipment> shipments = [];
    if (json['order_shipments'] != null) {
      shipments = (json['order_shipments'] as List)
          .map((item) => OrderShipment.fromJson(item))
          .toList();
    }

    return Order(
      id: json['id'].toString(),
      number: json['number'] ?? json['id'].toString(),
      items: items,
      totalAmount: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      shippingAddress: address,
      date: DateTime.parse(
        json['created_at'] ?? json['date'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'Pending',
      paymentMethod:
          json['payment_method_name'] ?? json['paymentMethod'] ?? 'Credit Card',
      shipments: shipments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress.toJson(),
      'date': date.toIso8601String(),
      'status': status,
      'paymentMethod': paymentMethod,
      'shipments': shipments.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderShipment {
  final String expressCompany;
  final String expressNumber;

  OrderShipment({required this.expressCompany, required this.expressNumber});

  factory OrderShipment.fromJson(Map<String, dynamic> json) {
    return OrderShipment(
      expressCompany: json['express_company'] ?? '',
      expressNumber: json['express_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'express_company': expressCompany, 'express_number': expressNumber};
  }
}
