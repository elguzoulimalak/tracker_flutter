class FuelEntry {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double liters;
  final double totalAmount;
  final double mileage;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get pricePerLiter {
    if (liters == 0) return 0;
    return totalAmount / liters;
  }

  FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.totalAmount,
    required this.mileage,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      date: DateTime.parse(json['date'] as String),
      liters: (json['liters'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      mileage: (json['mileage'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'date': date.toIso8601String(),
      'liters': liters,
      'totalAmount': totalAmount,
      'mileage': mileage,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  FuelEntry copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    double? liters,
    double? totalAmount,
    double? mileage,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      liters: liters ?? this.liters,
      totalAmount: totalAmount ?? this.totalAmount,
      mileage: mileage ?? this.mileage,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
