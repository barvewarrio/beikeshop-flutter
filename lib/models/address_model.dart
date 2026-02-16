class Address {
  final String id;
  final String name;
  final String phone;
  final String country;
  final String province;
  final String city;
  final String addressLine;
  final String zipCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.country,
    required this.province,
    required this.city,
    required this.addressLine,
    required this.zipCode,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      addressLine: json['address_line'] ?? '',
      zipCode: json['zip_code'] ?? '',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'country': country,
      'province': province,
      'city': city,
      'address_line': addressLine,
      'zip_code': zipCode,
      'is_default': isDefault,
    };
  }

  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? country,
    String? province,
    String? city,
    String? addressLine,
    String? zipCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      addressLine: addressLine ?? this.addressLine,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
