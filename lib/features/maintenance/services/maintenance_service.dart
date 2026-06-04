import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance.dart';

class MaintenanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<Maintenance> addMaintenance({
    required String uid,
    required String vehicleId,
    required String categoryId,
    required String categoryName,
    required DateTime date,
    required double cost,
    required double mileage,
    String? description,
  }) async {
    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      final maintenance = Maintenance(
        id: id,
        vehicleId: vehicleId,
        categoryId: categoryId,
        categoryName: categoryName,
        date: date,
        cost: cost,
        mileage: mileage,
        description: description,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenances')
          .doc(id)
          .set(maintenance.toJson());

      return maintenance;
    } catch (e) {
      rethrow;
    }
  }

  Future<Maintenance> updateMaintenance({
    required String uid,
    required String maintenanceId,
    required String vehicleId,
    required String categoryId,
    required String categoryName,
    required DateTime date,
    required double cost,
    required double mileage,
    String? description,
  }) async {
    try {
      final now = DateTime.now();

      final maintenance = Maintenance(
        id: maintenanceId,
        vehicleId: vehicleId,
        categoryId: categoryId,
        categoryName: categoryName,
        date: date,
        cost: cost,
        mileage: mileage,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenances')
          .doc(maintenanceId)
          .update(maintenance.toJson());

      return maintenance;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMaintenance({
    required String uid,
    required String maintenanceId,
  }) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenances')
          .doc(maintenanceId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Maintenance>> getMaintenancesByVehicle({
    required String uid,
    required String vehicleId,
  }) {
    return _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection('maintenances')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Maintenance.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<Maintenance>> getAllMaintenances(String uid) {
    return _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection('maintenances')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Maintenance.fromJson(doc.data()))
          .toList();
    });
  }
}
