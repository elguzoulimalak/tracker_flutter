import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/dashboard/services/dashboard_service.dart';
import 'package:tracker_flutter/features/fuel/providers/fuel_provider.dart';
import 'package:tracker_flutter/features/maintenance/providers/maintenance_provider.dart';
import 'package:tracker_flutter/features/vehicles/providers/vehicle_provider.dart';

final dashboardServiceProvider = Provider((ref) => DashboardService());

final monthlyFuelExpensesProvider = Provider.autoDispose((ref) {
  final allFuelEntries = ref.watch(allFuelEntriesProvider);
  final dashboardService = ref.watch(dashboardServiceProvider);

  return allFuelEntries.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (entries) =>
        dashboardService.calculateMonthlyFuelExpenses(entries),
  );
});

final monthlyMaintenanceExpensesProvider = Provider.autoDispose((ref) {
  final allMaintenances = ref.watch(allMaintenancesProvider);
  final dashboardService = ref.watch(dashboardServiceProvider);

  return allMaintenances.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (entries) =>
        dashboardService.calculateMonthlyMaintenanceExpenses(entries),
  );
});

final monthlyFuelLitersProvider = Provider.autoDispose((ref) {
  final allFuelEntries = ref.watch(allFuelEntriesProvider);
  final dashboardService = ref.watch(dashboardServiceProvider);

  return allFuelEntries.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (entries) =>
        dashboardService.calculateMonthlyFuelLiters(entries),
  );
});

final totalVehiclesProvider = Provider.autoDispose((ref) {
  final vehicles = ref.watch(vehiclesProvider);
  return vehicles.when(
    loading: () => 0,
    error: (_, __) => 0,
    data: (data) => data.length,
  );
});

final totalFuelExpensesProvider = Provider.autoDispose((ref) {
  final allFuelEntries = ref.watch(allFuelEntriesProvider);
  final dashboardService = ref.watch(dashboardServiceProvider);

  return allFuelEntries.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (entries) =>
        dashboardService.calculateTotalFuelExpenses(entries),
  );
});

final totalMaintenanceExpensesProvider = Provider.autoDispose((ref) {
  final allMaintenances = ref.watch(allMaintenancesProvider);
  final dashboardService = ref.watch(dashboardServiceProvider);

  return allMaintenances.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (entries) =>
        dashboardService.calculateTotalMaintenanceExpenses(entries),
  );
});

final expensesRatioProvider = Provider.autoDispose((ref) {
  final fuelExpenses = ref.watch(monthlyFuelExpensesProvider);
  final maintenanceExpenses = ref.watch(monthlyMaintenanceExpensesProvider);
  final dashboardService = ref.watch(dashboardServiceProvider);

  return dashboardService.calculateExpensesRatio(
      fuelExpenses, maintenanceExpenses);
});
