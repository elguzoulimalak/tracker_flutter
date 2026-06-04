import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/vehicles/models/vehicle.dart';
import 'package:tracker_flutter/features/vehicles/providers/vehicle_provider.dart';
import 'package:tracker_flutter/shared/widgets/dialogs.dart';

class VehiclesListScreen extends HookConsumerWidget {
  const VehiclesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes véhicules'),
        elevation: 0,
      ),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Erreur: $err'),
        ),
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.directions_car,
              title: 'Aucun véhicule',
              message: 'Commencez par ajouter un véhicule',
              actionLabel: 'Ajouter un véhicule',
              onAction: () => context.push('/vehicles/add'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return _VehicleCard(vehicle: vehicle);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _VehicleCard extends HookConsumerWidget {
  final Vehicle vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text('${vehicle.brand} ${vehicle.model}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${vehicle.registrationNumber} - ${vehicle.year}'),
            const SizedBox(height: 4),
            Text('${vehicle.currentMileage.toStringAsFixed(0)} km'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () => context.push('/vehicles/${vehicle.id}'),
              child: const Text('Voir'),
            ),
            PopupMenuItem(
              onTap: () => context.push('/vehicles/${vehicle.id}/edit'),
              child: const Text('Éditer'),
            ),
            PopupMenuItem(
              onTap: () => _showDeleteConfirmation(context, ref),
              child: const Text('Supprimer'),
            ),
          ],
        ),
        onTap: () => context.push('/vehicles/${vehicle.id}'),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Supprimer le véhicule',
        message:
            'Êtes-vous sûr de vouloir supprimer ce véhicule ? Cette action est irréversible.',
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(deleteVehicleProvider(vehicle.id).future);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
