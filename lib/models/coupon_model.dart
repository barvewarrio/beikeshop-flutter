class Coupon {
  final String id;
  final String code;
  final String name;
  final String type;
  final double discount;
  final double minTotal;
  final String? startDate;
  final String? endDate;
  final bool status;

  Coupon({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.discount,
    required this.minTotal,
    this.startDate,
    this.endDate,
    required this.status,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'].toString(),
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'F',
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      minTotal: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      startDate: json['date_start'],
      endDate: json['date_end'],
      status: json['status'] == 1 || json['status'] == true,
    );
  }
}
