class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Zone {
  final int id;
  final String name;
  final String code;

  Zone({required this.id, required this.name, required this.code});

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}
