import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';
import 'package:tracker_flutter/features/fuel/models/fuel_entry.dart';
import 'package:tracker_flutter/features/fuel/services/fuel_service.dart';

final fuelServiceProvider = Provider((ref) => FuelService());

final fuelEntriesByVehicleProvider =
    StreamProvider.autoDispose.family<List<FuelEntry>, String>((ref, vehicleId) {
  final user = ref.watch(currentUserProvider);
  final fuelService = ref.watch(fuelServiceProvider);

  if (user == null) {
    return const AsyncValue.loading();
  }

  return fuelService
      .getFuelEntriesByVehicle(uid: user.uid, vehicleId: vehicleId)
      .asBroadcastStream();
});

final allFuelEntriesProvider =
    StreamProvider.autoDispose<List<FuelEntry>>((ref) {
  final user = ref.watch(currentUserProvider);
  final fuelService = ref.watch(fuelServiceProvider);

  if (user == null) {
    return const AsyncValue.loading();
  }

  return fuelService.getAllFuelEntries(user.uid).asBroadcastStream();
});

final addFuelEntryProvider = FutureProvider.family<FuelEntry, Map<String, dynamic>>(
    (ref, params) async {
  final user = ref.watch(currentUserProvider);
  final fuelService = ref.watch(fuelServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final fuelEntry = await fuelService.addFuelEntry(
    uid: user.uid,
    vehicleId: params['vehicleId'] as String,
    date: params['date'] as DateTime,
    liters: params['liters'] as double,
    totalAmount: params['totalAmount'] as double,
    mileage: params['mileage'] as double,
    notes: params['notes'] as String?,
  );

  ref.invalidate(fuelEntriesByVehicleProvider);
  ref.invalidate(allFuelEntriesProvider);
  return fuelEntry;
});

final updateFuelEntryProvider = FutureProvider.family<FuelEntry, Map<String, dynamic>>(
    (ref, params) async {
  final user = ref.watch(currentUserProvider);
  final fuelService = ref.watch(fuelServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  final fuelEntry = await fuelService.updateFuelEntry(
    uid: user.uid,
    entryId: params['entryId'] as String,
    vehicleId: params['vehicleId'] as String,
    date: params['date'] as DateTime,
    liters: params['liters'] as double,
    totalAmount: params['totalAmount'] as double,
    mileage: params['mileage'] as double,
    notes: params['notes'] as String?,
  );

  ref.invalidate(fuelEntriesByVehicleProvider);
  ref.invalidate(allFuelEntriesProvider);
  return fuelEntry;
});

final deleteFuelEntryProvider =
    FutureProvider.family<void, String>((ref, entryId) async {
  final user = ref.watch(currentUserProvider);
  final fuelService = ref.watch(fuelServiceProvider);

  if (user == null) throw Exception('User not authenticated');

  await fuelService.deleteFuelEntry(
    uid: user.uid,
    entryId: entryId,
  );

  ref.invalidate(fuelEntriesByVehicleProvider);
  ref.invalidate(allFuelEntriesProvider);
});
