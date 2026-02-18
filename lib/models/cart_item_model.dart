import 'models.dart';

class CartItem {
  final String? id; // Cart Item ID (for update/delete)
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({
    this.id,
    required this.product,
    this.quantity = 1,
    this.isSelected = true,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString(),
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      isSelected: json['isSelected'] ?? true,
    );
  }

  factory CartItem.fromBackendJson(Map<String, dynamic> json) {
    // Construct a Product object from the flat cart details
    final product = Product(
      id: json['product_id']?.toString() ?? '',
      title: json['name'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      // Default values for missing fields
      description: '',
      sales: 0,
      rating: 0.0,
      isFlashSale: false,
      tags: [],
    );

    return CartItem(
      id: json['cart_id']?.toString(), // Map backend 'cart_id' to 'id'
      product: product,
      quantity: json['quantity'] ?? 1,
      isSelected: json['selected'] == 1 || json['selected'] == true,
    );
  }
}
