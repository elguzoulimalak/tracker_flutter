import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/fuel/models/fuel_entry.dart';
import 'package:tracker_flutter/features/fuel/providers/fuel_provider.dart';
import 'package:tracker_flutter/shared/widgets/dialogs.dart';
import 'package:intl/intl.dart';

class FuelHistoryScreen extends HookConsumerWidget {
  final String? vehicleId;

  const FuelHistoryScreen({super.key, this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelEntriesAsync = vehicleId != null
        ? ref.watch(fuelEntriesByVehicleProvider(vehicleId!))
        : ref.watch(allFuelEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des pleins'),
        elevation: 0,
      ),
      body: fuelEntriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (entries) {
          if (entries.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.local_gas_station,
              title: 'Aucun plein',
              message: 'Aucun plein enregistré pour le moment',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _FuelEntryCard(
                entry: entry,
                onDelete: () => _showDeleteConfirmation(context, ref, entry),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, FuelEntry entry) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Supprimer le plein',
        message: 'Êtes-vous sûr de vouloir supprimer ce plein ?',
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(deleteFuelEntryProvider(entry.id).future);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}

class _FuelEntryCard extends StatelessWidget {
  final FuelEntry entry;
  final VoidCallback onDelete;

  const _FuelEntryCard({
    required this.entry,
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
                Text(
                  dateFormat.format(entry.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${entry.liters} L'),
                Text('${entry.totalAmount.toStringAsFixed(2)} €'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Prix/L: ${entry.pricePerLiter.toStringAsFixed(3)} €',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Km: ${entry.mileage.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.grey),
            ),
            if (entry.notes != null && entry.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${entry.notes}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
