import 'package:flutter_test/flutter_test.dart';
import 'package:tracker_flutter/features/vehicles/models/vehicle.dart';
import 'package:tracker_flutter/features/fuel/models/fuel_entry.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance_category.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance.dart';

void main() {
  group('Models Tests', () {
    test('Vehicle model should be created correctly', () {
      final now = DateTime.now();
      final vehicle = Vehicle(
        id: 'v1',
        name: 'Voiture',
        brand: 'Toyota',
        model: 'Corolla',
        registrationNumber: 'AB-123-CD',
        year: 2021,
        currentMileage: 100000.0,
        createdAt: now,
        updatedAt: now,
      );

      expect(vehicle.id, 'v1');
      expect(vehicle.brand, 'Toyota');
      expect(vehicle.currentMileage, 100000.0);
    });

    test('Vehicle toJson and fromJson should work correctly', () {
      final now = DateTime.now();
      final original = Vehicle(
        id: 'v1',
        name: 'Voiture',
        brand: 'Toyota',
        model: 'Corolla',
        registrationNumber: 'AB-123-CD',
        year: 2021,
        currentMileage: 100000.0,
        createdAt: now,
        updatedAt: now,
      );

      final json = original.toJson();
      final restored = Vehicle.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.brand, original.brand);
      expect(restored.currentMileage, original.currentMileage);
    });

    test('FuelEntry pricePerLiter should be calculated correctly', () {
      final now = DateTime.now();
      final entry = FuelEntry(
        id: 'f1',
        vehicleId: 'v1',
        date: now,
        liters: 50.0,
        totalAmount: 75.0,
        mileage: 100000.0,
        createdAt: now,
        updatedAt: now,
      );

      expect(entry.pricePerLiter, 1.5);
    });

    test('FuelEntry pricePerLiter should handle zero liters', () {
      final now = DateTime.now();
      final entry = FuelEntry(
        id: 'f1',
        vehicleId: 'v1',
        date: now,
        liters: 0.0,
        totalAmount: 0.0,
        mileage: 100000.0,
        createdAt: now,
        updatedAt: now,
      );

      expect(entry.pricePerLiter, 0);
    });

    test('MaintenanceCategory model should be created correctly', () {
      final now = DateTime.now();
      final category = MaintenanceCategory(
        id: 'cat1',
        name: 'Vidange',
        description: 'Changement d\'huile',
        createdAt: now,
        updatedAt: now,
      );

      expect(category.id, 'cat1');
      expect(category.name, 'Vidange');
    });

    test('Maintenance model should be created correctly', () {
      final now = DateTime.now();
      final maintenance = Maintenance(
        id: 'm1',
        vehicleId: 'v1',
        categoryId: 'cat1',
        categoryName: 'Vidange',
        date: now,
        cost: 100.0,
        mileage: 100000.0,
        description: 'Vidange complète',
        createdAt: now,
        updatedAt: now,
      );

      expect(maintenance.id, 'm1');
      expect(maintenance.categoryName, 'Vidange');
      expect(maintenance.cost, 100.0);
    });
  });
}
