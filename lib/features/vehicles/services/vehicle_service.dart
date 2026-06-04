import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:tracker_flutter/features/vehicles/models/vehicle.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<Vehicle> addVehicle({
    required String uid,
    required String name,
    required String brand,
    required String model,
    required String registrationNumber,
    required int year,
    required double currentMileage,
  }) async {
    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      final vehicle = Vehicle(
        id: id,
        name: name,
        brand: brand,
        model: model,
        registrationNumber: registrationNumber,
        year: year,
        currentMileage: currentMileage,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('vehicles')
          .doc(id)
          .set(vehicle.toJson());

      return vehicle;
    } catch (e) {
      rethrow;
    }
  }

  Future<Vehicle> updateVehicle({
    required String uid,
    required String vehicleId,
    required String name,
    required String brand,
    required String model,
    required String registrationNumber,
    required int year,
    required double currentMileage,
  }) async {
    try {
      final now = DateTime.now();

      final vehicle = Vehicle(
        id: vehicleId,
        name: name,
        brand: brand,
        model: model,
        registrationNumber: registrationNumber,
        year: year,
        currentMileage: currentMileage,
        createdAt: DateTime.now(),
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('vehicles')
          .doc(vehicleId)
          .update(vehicle.toJson());

      return vehicle;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteVehicle({
    required String uid,
    required String vehicleId,
  }) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('vehicles')
          .doc(vehicleId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Vehicle>> getVehicles(String uid) {
    return _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection('vehicles')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Vehicle.fromJson(doc.data()))
          .toList();
    });
  }

  Future<Vehicle?> getVehicleById({
    required String uid,
    required String vehicleId,
  }) async {
    try {
      final doc = await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('vehicles')
          .doc(vehicleId)
          .get();

      if (doc.exists) {
        return Vehicle.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
