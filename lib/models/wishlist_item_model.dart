import 'models.dart';

class WishlistItem {
  final String id;
  final Product product;

  WishlistItem({
    required this.id,
    required this.product,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'].toString(),
      product: Product.fromJson(json['product']),
    );
  }
}
