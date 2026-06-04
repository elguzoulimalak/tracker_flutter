import 'package:flutter_test/flutter_test.dart';
import 'package:tracker_flutter/features/dashboard/services/dashboard_service.dart';
import 'package:tracker_flutter/features/fuel/models/fuel_entry.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance.dart';

void main() {
  group('Dashboard Service Tests', () {
    late DashboardService dashboardService;

    setUp(() {
      dashboardService = DashboardService();
    });

    test('Should calculate monthly fuel expenses correctly', () {
      final now = DateTime.now();
      final entries = [
        FuelEntry(
          id: 'f1',
          vehicleId: 'v1',
          date: now,
          liters: 50.0,
          totalAmount: 75.0,
          mileage: 100000.0,
          createdAt: now,
          updatedAt: now,
        ),
        FuelEntry(
          id: 'f2',
          vehicleId: 'v1',
          date: now.subtract(const Duration(days: 35)),
          liters: 50.0,
          totalAmount: 75.0,
          mileage: 100000.0,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final monthlyExpenses =
          dashboardService.calculateMonthlyFuelExpenses(entries);

      expect(monthlyExpenses, 75.0);
    });

    test('Should calculate monthly maintenance expenses correctly', () {
      final now = DateTime.now();
      final entries = [
        Maintenance(
          id: 'm1',
          vehicleId: 'v1',
          categoryId: 'cat1',
          categoryName: 'Vidange',
          date: now,
          cost: 100.0,
          mileage: 100000.0,
          createdAt: now,
          updatedAt: now,
        ),
        Maintenance(
          id: 'm2',
          vehicleId: 'v1',
          categoryId: 'cat1',
          categoryName: 'Vidange',
          date: now.subtract(const Duration(days: 35)),
          cost: 100.0,
          mileage: 100000.0,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final monthlyExpenses =
          dashboardService.calculateMonthlyMaintenanceExpenses(entries);

      expect(monthlyExpenses, 100.0);
    });

    test('Should calculate expenses ratio correctly', () {
      final ratio = dashboardService.calculateExpensesRatio(70.0, 30.0);

      expect(ratio['fuel'], 70.0);
      expect(ratio['maintenance'], 30.0);
    });

    test('Should handle zero total expenses in ratio calculation', () {
      final ratio = dashboardService.calculateExpensesRatio(0.0, 0.0);

      expect(ratio['fuel'], 0);
      expect(ratio['maintenance'], 0);
    });

    test('Should calculate total fuel liters correctly', () {
      final now = DateTime.now();
      final entries = [
        FuelEntry(
          id: 'f1',
          vehicleId: 'v1',
          date: now,
          liters: 50.0,
          totalAmount: 75.0,
          mileage: 100000.0,
          createdAt: now,
          updatedAt: now,
        ),
        FuelEntry(
          id: 'f2',
          vehicleId: 'v1',
          date: now,
          liters: 30.0,
          totalAmount: 45.0,
          mileage: 100000.0,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      final totalLiters = dashboardService.calculateTotalFuelLiters(entries);

      expect(totalLiters, 80.0);
    });
  });
}
