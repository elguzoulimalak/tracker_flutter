import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/maintenance/providers/maintenance_provider.dart';
import 'package:tracker_flutter/features/vehicles/providers/vehicle_provider.dart';

class AddMaintenanceScreen extends HookConsumerWidget {
  final String? vehicleId;

  const AddMaintenanceScreen({super.key, this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateController = useTextEditingController();
    final costController = useTextEditingController();
    final mileageController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final selectedVehicleId = useState(vehicleId);
    final selectedCategoryId = useState<String?>(null);
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);

    final vehiclesAsync = ref.watch(vehiclesProvider);
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une maintenance'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (vehiclesAsync.hasValue && vehiclesAsync.value!.isNotEmpty)
              DropdownButtonFormField<String>(
                value: selectedVehicleId.value,
                items: vehiclesAsync.value!.map((v) {
                  return DropdownMenuItem(
                    value: v.id,
                    child: Text('${v.brand} ${v.model}'),
                  );
                }).toList(),
                onChanged: (value) => selectedVehicleId.value = value,
                decoration: const InputDecoration(labelText: 'Véhicule'),
              ),
            const SizedBox(height: 16),
            if (categoriesAsync.hasValue && categoriesAsync.value!.isNotEmpty)
              DropdownButtonFormField<String>(
                value: selectedCategoryId.value,
                items: categoriesAsync.value!.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name),
                  );
                }).toList(),
                onChanged: (value) => selectedCategoryId.value = value,
                decoration: const InputDecoration(labelText: 'Catégorie'),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  dateController.text = date.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Coût (€)',
                prefixIcon: Icon(Icons.euro),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: mileageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilométrage',
                prefixIcon: Icon(Icons.speed),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optionnel)',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            if (errorMessage.value != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(color: Colors.red.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage.value!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ElevatedButton(
              onPressed: isLoading.value
                  ? null
                  : () async {
                      if (selectedVehicleId.value == null ||
                          selectedCategoryId.value == null ||
                          dateController.text.isEmpty ||
                          costController.text.isEmpty ||
                          mileageController.text.isEmpty) {
                        errorMessage.value =
                            'Veuillez remplir tous les champs obligatoires';
                        return;
                      }

                      isLoading.value = true;
                      errorMessage.value = null;

                      try {
                        final selectedCategory =
                            categoriesAsync.value!.firstWhere(
                          (c) => c.id == selectedCategoryId.value,
                        );

                        await ref.read(
                          addMaintenanceProvider({
                            'vehicleId': selectedVehicleId.value!,
                            'categoryId': selectedCategoryId.value!,
                            'categoryName': selectedCategory.name,
                            'date': DateTime.parse(dateController.text),
                            'cost': double.parse(costController.text),
                            'mileage': double.parse(mileageController.text),
                            'description':
                                descriptionController.text.isEmpty
                                    ? null
                                    : descriptionController.text,
                          }).future,
                        );

                        if (context.mounted) {
                          context.pop();
                        }
                      } catch (e) {
                        errorMessage.value = e.toString();
                      } finally {
                        isLoading.value = false;
                      }
                    },
              child: isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
