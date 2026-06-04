import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';
import 'package:tracker_flutter/features/vehicles/models/vehicle.dart';
import 'package:tracker_flutter/features/vehicles/services/vehicle_service.dart';

final vehicleServiceProvider = Provider((ref) => VehicleService());

final vehiclesProvider = StreamProvider.autoDispose<List<Vehicle>>((ref) {
  final user = ref.watch(currentUserProvider);
  final vehicleService = ref.watch(vehicleServiceProvider);

  if (user == null) {
    return const AsyncValue.loading();
  }

  return vehicleService.getVehicles(user.uid).asBroadcastStream();
});

final addVehicleProvider =
    FutureProvider.family<Vehicle, Map<String, dynamic>>((ref, params) async {
  final user = ref.watch(currentUserProvider);
  final vehicleService = ref.watch(vehicleServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final vehicle = await vehicleService.addVehicle(
    uid: user.uid,
    name: params['name'] as String,
    brand: params['brand'] as String,
    model: params['model'] as String,
    registrationNumber: params['registrationNumber'] as String,
    year: params['year'] as int,
    currentMileage: params['currentMileage'] as double,
  );

  ref.invalidate(vehiclesProvider);
  return vehicle;
});

final updateVehicleProvider =
    FutureProvider.family<Vehicle, Map<String, dynamic>>((ref, params) async {
  final user = ref.watch(currentUserProvider);
  final vehicleService = ref.watch(vehicleServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final vehicle = await vehicleService.updateVehicle(
    uid: user.uid,
    vehicleId: params['vehicleId'] as String,
    name: params['name'] as String,
    brand: params['brand'] as String,
    model: params['model'] as String,
    registrationNumber: params['registrationNumber'] as String,
    year: params['year'] as int,
    currentMileage: params['currentMileage'] as double,
  );

  ref.invalidate(vehiclesProvider);
  return vehicle;
});

final deleteVehicleProvider =
    FutureProvider.family<void, String>((ref, vehicleId) async {
  final user = ref.watch(currentUserProvider);
  final vehicleService = ref.watch(vehicleServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  await vehicleService.deleteVehicle(
    uid: user.uid,
    vehicleId: vehicleId,
  );

  ref.invalidate(vehiclesProvider);
});
