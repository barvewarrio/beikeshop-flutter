class PaymentMethod {
  final String code;
  final String name;
  final String description;
  final String icon;
  final String type;

  PaymentMethod({
    required this.code,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? 'payment',
    );
  }
}
