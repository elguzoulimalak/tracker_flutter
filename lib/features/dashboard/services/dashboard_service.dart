import 'package:tracker_flutter/features/fuel/models/fuel_entry.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance.dart';

class DashboardService {
  double calculateMonthlyFuelExpenses(List<FuelEntry> entries) {
    final now = DateTime.now();
    final currentMonth = entries.where((e) =>
        e.date.year == now.year && e.date.month == now.month);
    return currentMonth.fold(0.0, (sum, e) => sum + e.totalAmount);
  }

  double calculateMonthlyMaintenanceExpenses(List<Maintenance> entries) {
    final now = DateTime.now();
    final currentMonth = entries.where((e) =>
        e.date.year == now.year && e.date.month == now.month);
    return currentMonth.fold(0.0, (sum, e) => sum + e.cost);
  }

  double calculateMonthlyFuelLiters(List<FuelEntry> entries) {
    final now = DateTime.now();
    final currentMonth = entries.where((e) =>
        e.date.year == now.year && e.date.month == now.month);
    return currentMonth.fold(0.0, (sum, e) => sum + e.liters);
  }

  double calculateTotalFuelExpenses(List<FuelEntry> entries) {
    return entries.fold(0.0, (sum, e) => sum + e.totalAmount);
  }

  double calculateTotalMaintenanceExpenses(List<Maintenance> entries) {
    return entries.fold(0.0, (sum, e) => sum + e.cost);
  }

  double calculateTotalFuelLiters(List<FuelEntry> entries) {
    return entries.fold(0.0, (sum, e) => sum + e.liters);
  }

  Map<String, double> calculateExpensesRatio(
      double fuelExpenses, double maintenanceExpenses) {
    final total = fuelExpenses + maintenanceExpenses;
    if (total == 0) {
      return {'fuel': 0, 'maintenance': 0};
    }
    return {
      'fuel': (fuelExpenses / total) * 100,
      'maintenance': (maintenanceExpenses / total) * 100,
    };
  }
}
