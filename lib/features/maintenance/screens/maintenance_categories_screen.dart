import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance_category.dart';
import 'package:tracker_flutter/features/maintenance/providers/maintenance_provider.dart';
import 'package:tracker_flutter/shared/widgets/dialogs.dart';

class MaintenanceCategoriesScreen extends HookConsumerWidget {
  const MaintenanceCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final isLoading = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catégories de maintenance'),
        elevation: 0,
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
        data: (categories) {
          return Column(
            children: [
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Text(
                          'Aucune catégorie',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return _CategoryTile(
                            category: category,
                            onDelete: () =>
                                _showDeleteConfirmation(context, ref, category),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nouvelle catégorie',
                        prefixIcon: Icon(Icons.category),
                      ),
                      enabled: !isLoading.value,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optionnel)',
                        prefixIcon: Icon(Icons.description),
                      ),
                      enabled: !isLoading.value,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              if (nameController.text.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Entrez un nom de catégorie'),
                                  ),
                                );
                                return;
                              }

                              isLoading.value = true;

                              try {
                                await ref.read(
                                  addMaintenanceCategoryProvider({
                                    'name': nameController.text,
                                    'description':
                                        descriptionController.text.isEmpty
                                            ? null
                                            : descriptionController.text,
                                  }).future,
                                );

                                nameController.clear();
                                descriptionController.clear();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(content: Text('Erreur: $e')),
                                  );
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                      child: isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Ajouter'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, MaintenanceCategory category) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Supprimer la catégorie',
        message: 'Êtes-vous sûr de vouloir supprimer cette catégorie ?',
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(deleteMaintenanceCategoryProvider(category.id).future);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final MaintenanceCategory category;
  final VoidCallback onDelete;

  const _CategoryTile({
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(category.name),
        subtitle: category.description != null
            ? Text(category.description!)
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
