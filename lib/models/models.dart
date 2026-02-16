class Product {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int sales;
  final double rating;
  final bool isFlashSale;
  final List<String> tags;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.sales = 0,
    this.rating = 0.0,
    this.isFlashSale = false,
    this.tags = const [],
  });

  double get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      originalPrice: json['original_price'] != null
          ? double.tryParse(json['original_price'].toString())
          : null,
      sales: int.tryParse(json['sales_count']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      isFlashSale: json['is_flash_sale'] ?? false,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'image': imageUrl,
      'price': price,
      'original_price': originalPrice,
      'sales_count': sales,
      'rating': rating,
      'is_flash_sale': isFlashSale,
      'tags': tags,
    };
  }
}

class Category {
  final String id;
  final String name;
  final String? imageUrl;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.children = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var childrenJson = json['children'] as List?;
    List<Category> childrenList = childrenJson != null
        ? childrenJson.map((i) => Category.fromJson(i)).toList()
        : [];

    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrl: json['image'],
      children: childrenList,
    );
  }
}
