import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/vehicles/models/vehicle.dart';
import 'package:tracker_flutter/features/vehicles/services/vehicle_service.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';
import 'package:tracker_flutter/features/fuel/providers/fuel_provider.dart';
import 'package:tracker_flutter/features/maintenance/providers/maintenance_provider.dart';

class VehicleDetailsScreen extends HookConsumerWidget {
  final String vehicleId;

  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = useState<AsyncValue<Vehicle?>>(const AsyncValue.loading());
    final user = ref.watch(currentUserProvider);
    final fuelEntries = ref.watch(fuelEntriesByVehicleProvider(vehicleId));
    final maintenances = ref.watch(maintenancesByVehicleProvider(vehicleId));

    useEffect(() {
      if (user != null) {
        _loadVehicle(ref);
      }
      return null;
    }, [user]);

    Future<void> _loadVehicle(WidgetRef ref) async {
      final vehicleService = VehicleService();
      try {
        final vehicle = await vehicleService.getVehicleById(
          uid: user!.uid,
          vehicleId: vehicleId,
        );
        vehicleAsync.value = AsyncValue.data(vehicle);
      } catch (e) {
        vehicleAsync.value = AsyncValue.error(e, StackTrace.current);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du véhicule'),
        elevation: 0,
      ),
      body: vehicleAsync.value.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('Véhicule non trouvé'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${vehicle.brand} ${vehicle.model}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Nom: ${vehicle.name}'),
                        Text(
                            'Immatriculation: ${vehicle.registrationNumber}'),
                        Text('Année: ${vehicle.year}'),
                        Text(
                            'Kilométrage: ${vehicle.currentMileage.toStringAsFixed(0)} km'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/vehicles/${vehicle.id}/edit'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Éditer'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/fuel/add?vehicleId=${vehicle.id}'),
                    icon: const Icon(Icons.local_gas_station),
                    label: const Text('Ajouter un plein'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/maintenance/add?vehicleId=${vehicle.id}'),
                    icon: const Icon(Icons.build),
                    label: const Text('Ajouter une maintenance'),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Dernier plein',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                fuelEntries.when(
                  loading: () =>
                      const CircularProgressIndicator(),
                  error: (err, stack) => Text('Erreur: $err'),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return const Text('Aucun plein enregistré');
                    }
                    final last = entries.first;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${last.liters} L'),
                            Text('Prix: ${last.totalAmount.toStringAsFixed(2)} €'),
                            Text(
                                'Prix/L: ${last.pricePerLiter.toStringAsFixed(3)} €'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
