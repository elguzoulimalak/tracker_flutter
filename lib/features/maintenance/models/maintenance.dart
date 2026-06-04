class Maintenance {
  final String id;
  final String vehicleId;
  final String categoryId;
  final String categoryName;
  final DateTime date;
  final double cost;
  final double mileage;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.categoryId,
    required this.categoryName,
    required this.date,
    required this.cost,
    required this.mileage,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      date: DateTime.parse(json['date'] as String),
      cost: (json['cost'] as num).toDouble(),
      mileage: (json['mileage'] as num).toDouble(),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'date': date.toIso8601String(),
      'cost': cost,
      'mileage': mileage,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Maintenance copyWith({
    String? id,
    String? vehicleId,
    String? categoryId,
    String? categoryName,
    DateTime? date,
    double? cost,
    double? mileage,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Maintenance(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      date: date ?? this.date,
      cost: cost ?? this.cost,
      mileage: mileage ?? this.mileage,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
