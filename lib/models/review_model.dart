class Review {
  final int id;
  final String customerName;
  final int rating;
  final String? comment;
  final List<String> images;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.customerName,
    required this.rating,
    this.comment,
    this.images = const [],
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      customerName: json['customer_name'] ?? 'Guest',
      rating: json['rating'] ?? 5,
      comment: json['comment'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
