class Address {
  final String id;
  final String name;
  final String phone;
  final String country;
  final int countryId;
  final String province;
  final int zoneId;
  final String city;
  final String addressLine;
  final String zipCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.country,
    this.countryId = 0,
    required this.province,
    this.zoneId = 0,
    required this.city,
    required this.addressLine,
    required this.zipCode,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    String countryName = '';
    int cId = 0;
    
    if (json['country'] is Map) {
      countryName = json['country']['name'] ?? '';
      cId = json['country']['id'] ?? 0;
    } else {
      cId = int.tryParse(json['country_id']?.toString() ?? '0') ?? 0;
      // Name might be missing if only ID is provided, handled by UI fetching list
    }

    String provinceName = '';
    int zId = 0;
    
    if (json['zone'] is Map) {
      provinceName = json['zone']['name'] ?? '';
      zId = json['zone']['id'] ?? 0;
    } else {
      zId = int.tryParse(json['zone_id']?.toString() ?? '0') ?? 0;
    }

    return Address(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      country: countryName,
      countryId: cId,
      province: provinceName,
      zoneId: zId,
      city: json['city'] ?? '',
      addressLine: json['address_1'] ?? '',
      zipCode: json['zipcode'] ?? json['zip_code'] ?? '',
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'country_id': countryId,
      'zone_id': zoneId,
      'city': city,
      'address_1': addressLine,
      'zip_code': zipCode,
      'is_default': isDefault,
    };
  }

  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? country,
    int? countryId,
    String? province,
    int? zoneId,
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
      countryId: countryId ?? this.countryId,
      province: province ?? this.province,
      zoneId: zoneId ?? this.zoneId,
      city: city ?? this.city,
      addressLine: addressLine ?? this.addressLine,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
