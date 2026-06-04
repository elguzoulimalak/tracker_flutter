import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance.dart';
import 'package:tracker_flutter/features/maintenance/providers/maintenance_provider.dart';
import 'package:tracker_flutter/shared/widgets/dialogs.dart';
import 'package:intl/intl.dart';

class MaintenanceHistoryScreen extends HookConsumerWidget {
  final String? vehicleId;

  const MaintenanceHistoryScreen({super.key, this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenancesAsync = vehicleId != null
        ? ref.watch(maintenancesByVehicleProvider(vehicleId!))
        : ref.watch(allMaintenancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des maintenances'),
        elevation: 0,
      ),
      body: maintenancesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (maintenances) {
          if (maintenances.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.build,
              title: 'Aucune maintenance',
              message: 'Aucune maintenance enregistrée pour le moment',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: maintenances.length,
            itemBuilder: (context, index) {
              final maintenance = maintenances[index];
              return _MaintenanceCard(
                maintenance: maintenance,
                onDelete: () =>
                    _showDeleteConfirmation(context, ref, maintenance),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, Maintenance maintenance) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Supprimer la maintenance',
        message: 'Êtes-vous sûr de vouloir supprimer cette maintenance ?',
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(deleteMaintenanceProvider(maintenance.id).future);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final Maintenance maintenance;
  final VoidCallback onDelete;

  const _MaintenanceCard({
    required this.maintenance,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maintenance.categoryName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(maintenance.date),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coût: ${maintenance.cost.toStringAsFixed(2)} €'),
                Text('Km: ${maintenance.mileage.toStringAsFixed(0)}'),
              ],
            ),
            if (maintenance.description != null &&
                maintenance.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Description: ${maintenance.description}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
