import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_flutter/features/vehicles/models/vehicle.dart';
import 'package:tracker_flutter/features/vehicles/providers/vehicle_provider.dart';
import 'package:tracker_flutter/features/vehicles/services/vehicle_service.dart';
import 'package:tracker_flutter/features/auth/providers/auth_provider.dart';

class AddEditVehicleScreen extends HookConsumerWidget {
  final String? vehicleId;

  const AddEditVehicleScreen({super.key, this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final brandController = useTextEditingController();
    final modelController = useTextEditingController();
    final registrationController = useTextEditingController();
    final yearController = useTextEditingController();
    final mileageController = useTextEditingController();
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final isEditing = vehicleId != null;

    useEffect(() {
      if (isEditing) {
        _loadVehicle(ref);
      }
      return null;
    }, [isEditing]);

    Future<void> _loadVehicle(WidgetRef ref) async {
      final user = ref.read(currentUserProvider);
      final vehicleService = VehicleService();

      if (user != null) {
        final vehicle =
            await vehicleService.getVehicleById(uid: user.uid, vehicleId: vehicleId!);
        if (vehicle != null) {
          nameController.text = vehicle.name;
          brandController.text = vehicle.brand;
          modelController.text = vehicle.model;
          registrationController.text = vehicle.registrationNumber;
          yearController.text = vehicle.year.toString();
          mileageController.text = vehicle.currentMileage.toString();
        }
      }
    }

    Future<void> _saveVehicle() async {
      if (nameController.text.isEmpty ||
          brandController.text.isEmpty ||
          modelController.text.isEmpty ||
          registrationController.text.isEmpty ||
          yearController.text.isEmpty ||
          mileageController.text.isEmpty) {
        errorMessage.value = 'Veuillez remplir tous les champs';
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;

      try {
        final params = {
          'name': nameController.text,
          'brand': brandController.text,
          'model': modelController.text,
          'registrationNumber': registrationController.text,
          'year': int.parse(yearController.text),
          'currentMileage': double.parse(mileageController.text),
        };

        if (isEditing) {
          params['vehicleId'] = vehicleId!;
          await ref.read(updateVehicleProvider(params).future);
        } else {
          await ref.read(addVehicleProvider(params).future);
        }

        if (context.mounted) {
          context.pop();
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Éditer le véhicule' : 'Ajouter un véhicule'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du véhicule',
                prefixIcon: Icon(Icons.directions_car),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(
                labelText: 'Marque',
                prefixIcon: Icon(Icons.badge),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: modelController,
              decoration: const InputDecoration(
                labelText: 'Modèle',
                prefixIcon: Icon(Icons.badge),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: registrationController,
              decoration: const InputDecoration(
                labelText: 'Numéro d\'immatriculation',
                prefixIcon: Icon(Icons.badge),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Année',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: mileageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilométrage actuel',
                prefixIcon: Icon(Icons.speed),
              ),
              enabled: !isLoading.value,
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
              onPressed: isLoading.value ? null : _saveVehicle,
              child: isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Mettre à jour' : 'Créer'),
            ),
          ],
        ),
      ),
    );
  }
}
