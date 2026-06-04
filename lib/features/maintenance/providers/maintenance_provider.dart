import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance_category.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance.dart';
import 'package:tracker_flutter/features/maintenance/services/maintenance_category_service.dart';
import 'package:tracker_flutter/features/maintenance/services/maintenance_service.dart';

final maintenanceCategoryServiceProvider =
    Provider((ref) => MaintenanceCategoryService());

final maintenanceServiceProvider =
    Provider((ref) => MaintenanceService());

final maintenanceCategoriesProvider =
    StreamProvider.autoDispose<List<MaintenanceCategory>>((ref) {
  final user = ref.watch(currentUserProvider);
  final categoryService = ref.watch(maintenanceCategoryServiceProvider);

  if (user == null) {
    return const AsyncValue.loading();
  }

  return categoryService.getCategories(user.uid).asBroadcastStream();
});

final addMaintenanceCategoryProvider =
    FutureProvider.family<MaintenanceCategory, Map<String, dynamic>>(
        (ref, params) async {
  final user = ref.watch(currentUserProvider);
  final categoryService = ref.watch(maintenanceCategoryServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final category = await categoryService.addCategory(
    uid: user.uid,
    name: params['name'] as String,
    description: params['description'] as String?,
  );

  ref.invalidate(maintenanceCategoriesProvider);
  return category;
});

final updateMaintenanceCategoryProvider =
    FutureProvider.family<MaintenanceCategory, Map<String, dynamic>>(
        (ref, params) async {
  final user = ref.watch(currentUserProvider);
  final categoryService = ref.watch(maintenanceCategoryServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final category = await categoryService.updateCategory(
    uid: user.uid,
    categoryId: params['categoryId'] as String,
    name: params['name'] as String,
    description: params['description'] as String?,
  );

  ref.invalidate(maintenanceCategoriesProvider);
  return category;
});

final deleteMaintenanceCategoryProvider =
    FutureProvider.family<void, String>((ref, categoryId) async {
  final user = ref.watch(currentUserProvider);
  final categoryService = ref.watch(maintenanceCategoryServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  await categoryService.deleteCategory(
    uid: user.uid,
    categoryId: categoryId,
  );

  ref.invalidate(maintenanceCategoriesProvider);
});

final maintenancesByVehicleProvider =
    StreamProvider.autoDispose.family<List<Maintenance>, String>(
        (ref, vehicleId) {
  final user = ref.watch(currentUserProvider);
  final maintenanceService = ref.watch(maintenanceServiceProvider);

  if (user == null) {
    return const AsyncValue.loading();
  }

  return maintenanceService
      .getMaintenancesByVehicle(uid: user.uid, vehicleId: vehicleId)
      .asBroadcastStream();
});

final allMaintenancesProvider =
    StreamProvider.autoDispose<List<Maintenance>>((ref) {
  final user = ref.watch(currentUserProvider);
  final maintenanceService = ref.watch(maintenanceServiceProvider);

  if (user == null) {
    return const AsyncValue.loading();
  }

  return maintenanceService.getAllMaintenances(user.uid).asBroadcastStream();
});

final addMaintenanceProvider =
    FutureProvider.family<Maintenance, Map<String, dynamic>>(
        (ref, params) async {
  final user = ref.watch(currentUserProvider);
  final maintenanceService = ref.watch(maintenanceServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final maintenance = await maintenanceService.addMaintenance(
    uid: user.uid,
    vehicleId: params['vehicleId'] as String,
    categoryId: params['categoryId'] as String,
    categoryName: params['categoryName'] as String,
    date: params['date'] as DateTime,
    cost: params['cost'] as double,
    mileage: params['mileage'] as double,
    description: params['description'] as String?,
  );

  ref.invalidate(maintenancesByVehicleProvider);
  ref.invalidate(allMaintenancesProvider);
  return maintenance;
});

final updateMaintenanceProvider =
    FutureProvider.family<Maintenance, Map<String, dynamic>>(
        (ref, params) async {
  final user = ref.watch(currentUserProvider);
  final maintenanceService = ref.watch(maintenanceServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final maintenance = await maintenanceService.updateMaintenance(
    uid: user.uid,
    maintenanceId: params['maintenanceId'] as String,
    vehicleId: params['vehicleId'] as String,
    categoryId: params['categoryId'] as String,
    categoryName: params['categoryName'] as String,
    date: params['date'] as DateTime,
    cost: params['cost'] as double,
    mileage: params['mileage'] as double,
    description: params['description'] as String?,
  );

  ref.invalidate(maintenancesByVehicleProvider);
  ref.invalidate(allMaintenancesProvider);
  return maintenance;
});

final deleteMaintenanceProvider =
    FutureProvider.family<void, String>((ref, maintenanceId) async {
  final user = ref.watch(currentUserProvider);
  final maintenanceService = ref.watch(maintenanceServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  await maintenanceService.deleteMaintenance(
    uid: user.uid,
    maintenanceId: maintenanceId,
  );

  ref.invalidate(maintenancesByVehicleProvider);
  ref.invalidate(allMaintenancesProvider);
});
