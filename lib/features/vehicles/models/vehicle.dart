class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String registrationNumber;
  final int year;
  final double currentMileage;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.registrationNumber,
    required this.year,
    required this.currentMileage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      registrationNumber: json['registrationNumber'] as String,
      year: json['year'] as int,
      currentMileage: (json['currentMileage'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'registrationNumber': registrationNumber,
      'year': year,
      'currentMileage': currentMileage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Vehicle copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? registrationNumber,
    int? year,
    double? currentMileage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      year: year ?? this.year,
      currentMileage: currentMileage ?? this.currentMileage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
