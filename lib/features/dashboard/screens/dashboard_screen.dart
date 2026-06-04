import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';
import 'package:tracker_flutter/features/dashboard/providers/dashboard_provider.dart';
import 'package:tracker_flutter/features/fuel/providers/fuel_provider.dart';
import 'package:tracker_flutter/features/maintenance/providers/maintenance_provider.dart';
import 'package:tracker_flutter/features/vehicles/providers/vehicle_provider.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final totalVehicles = ref.watch(totalVehiclesProvider);
    final monthlyFuel = ref.watch(monthlyFuelExpensesProvider);
    final monthlyMaintenance = ref.watch(monthlyMaintenanceExpensesProvider);
    final monthlyFuelLiters = ref.watch(monthlyFuelLitersProvider);
    final expensesRatio = ref.watch(expensesRatioProvider);
    final allFuelEntries = ref.watch(allFuelEntriesProvider);
    final allMaintenances = ref.watch(allMaintenancesProvider);
    final vehicles = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Profil'),
                onTap: () => context.push('/profile'),
              ),
              PopupMenuItem(
                child: const Text('Déconnexion'),
                onTap: () async {
                  await ref.read(signOutProvider.future);
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            authState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Erreur: $err')),
              data: (user) => user != null
                  ? Text(
                      'Bienvenue, ${user.email}',
                      style: const TextStyle(fontSize: 16),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 24),
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Véhicules',
                    value: totalVehicles.toString(),
                    icon: Icons.directions_car,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Carburant (€)',
                    value: monthlyFuel.toStringAsFixed(2),
                    icon: Icons.local_gas_station,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Maintenance (€)',
                    value: monthlyMaintenance.toStringAsFixed(2),
                    icon: Icons.build,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Carburant (L)',
                    value: monthlyFuelLiters.toStringAsFixed(1),
                    icon: Icons.opacity,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Expenses ratio
            _ExpensesRatioCard(ratio: expensesRatio),
            const SizedBox(height: 24),
            // Recent activities
            const Text(
              'Activités récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            allFuelEntries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Erreur: $err'),
              data: (fuelEntries) => allMaintenances.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Erreur: $err'),
                data: (maintenances) {
                  final allActivities = [
                    ...fuelEntries.map((f) => _Activity(
                          type: 'fuel',
                          date: f.date,
                          label:
                              '${f.liters} L - ${f.totalAmount.toStringAsFixed(2)} €',
                        )),
                    ...maintenances.map((m) => _Activity(
                          type: 'maintenance',
                          date: m.date,
                          label:
                              '${m.categoryName} - ${m.cost.toStringAsFixed(2)} €',
                        )),
                  ]..sort((a, b) => b.date.compareTo(a.date));

                  if (allActivities.isEmpty) {
                    return const Text(
                        'Aucune activité récente');
                  }

                  return Column(
                    children: allActivities.take(5).map((activity) {
                      return _ActivityTile(activity: activity);
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Quick actions
            _QuickActionsSection(),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesRatioCard extends StatelessWidget {
  final Map<String, double> ratio;

  const _ExpensesRatioCard({required this.ratio});

  @override
  Widget build(BuildContext context) {
    final fuelPercent = ratio['fuel'] ?? 0.0;
    final maintenancePercent = ratio['maintenance'] ?? 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Répartition des dépenses (ce mois)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      flex: fuelPercent.toInt(),
                      child: Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            '${fuelPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: maintenancePercent.toInt(),
                      child: Container(
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            '${maintenancePercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    const Text('Carburant'),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    const Text('Maintenance'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Activity {
  final String type;
  final DateTime date;
  final String label;

  _Activity({
    required this.type,
    required this.date,
    required this.label,
  });
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;

  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final icon = activity.type == 'fuel'
        ? Icons.local_gas_station
        : Icons.build;
    final color = activity.type == 'fuel'
        ? Colors.blue
        : Colors.orange;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(activity.label),
      subtitle: Text(dateFormat.format(activity.date)),
    );
  }
}

class _QuickActionsSection extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/vehicles'),
            icon: const Icon(Icons.directions_car),
            label: const Text('Mes véhicules'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/fuel/history'),
            icon: const Icon(Icons.local_gas_station),
            label: const Text('Historique carburant'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/maintenance/history'),
            icon: const Icon(Icons.build),
            label: const Text('Historique maintenance'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () =>
                context.push('/maintenance/categories'),
            icon: const Icon(Icons.category),
            label: const Text('Catégories'),
          ),
        ),
      ],
    );
  }
}

