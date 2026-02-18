class RmaReason {
  final String id;
  final String name;

  RmaReason({required this.id, required this.name});

  factory RmaReason.fromJson(Map<String, dynamic> json) {
    return RmaReason(id: json['id'].toString(), name: json['name'] ?? '');
  }
}

class Rma {
  final String id;
  final String orderId;
  final String orderProductId;
  final int quantity;
  final String reason;
  final String status;
  final String statusFormat;
  final String comment;
  final String createdAt;
  final String productName;
  final String sku;
  final String type;
  final String typeFormat;
  final bool opened;
  final String email;
  final String telephone;
  final String customerName;
  final List<String> images;

  Rma({
    required this.id,
    required this.orderId,
    required this.orderProductId,
    required this.quantity,
    required this.reason,
    required this.status,
    required this.statusFormat,
    required this.comment,
    required this.createdAt,
    required this.productName,
    required this.sku,
    required this.type,
    required this.typeFormat,
    required this.opened,
    required this.email,
    required this.telephone,
    required this.customerName,
    required this.images,
  });

  factory Rma.fromJson(Map<String, dynamic> json) {
    return Rma(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      orderProductId: json['order_product_id'].toString(),
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      statusFormat: json['status_format'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
      productName: json['product_name'] ?? '',
      sku: json['sku'] ?? '',
      type: json['type'] ?? '',
      typeFormat: json['type_format'] ?? '',
      opened: json['opened'] == 1 || json['opened'] == true,
      email: json['email'] ?? '',
      telephone: json['telephone'] ?? '',
      customerName: json['name'] ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
