import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:tracker_flutter/features/fuel/models/fuel_entry.dart';

class FuelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<FuelEntry> addFuelEntry({
    required String uid,
    required String vehicleId,
    required DateTime date,
    required double liters,
    required double totalAmount,
    required double mileage,
    String? notes,
  }) async {
    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      final fuelEntry = FuelEntry(
        id: id,
        vehicleId: vehicleId,
        date: date,
        liters: liters,
        totalAmount: totalAmount,
        mileage: mileage,
        notes: notes,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('fuelEntries')
          .doc(id)
          .set(fuelEntry.toJson());

      return fuelEntry;
    } catch (e) {
      rethrow;
    }
  }

  Future<FuelEntry> updateFuelEntry({
    required String uid,
    required String entryId,
    required String vehicleId,
    required DateTime date,
    required double liters,
    required double totalAmount,
    required double mileage,
    String? notes,
  }) async {
    try {
      final now = DateTime.now();

      final fuelEntry = FuelEntry(
        id: entryId,
        vehicleId: vehicleId,
        date: date,
        liters: liters,
        totalAmount: totalAmount,
        mileage: mileage,
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('fuelEntries')
          .doc(entryId)
          .update(fuelEntry.toJson());

      return fuelEntry;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFuelEntry({
    required String uid,
    required String entryId,
  }) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('fuelEntries')
          .doc(entryId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<FuelEntry>> getFuelEntriesByVehicle({
    required String uid,
    required String vehicleId,
  }) {
    return _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection('fuelEntries')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FuelEntry.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<FuelEntry>> getAllFuelEntries(String uid) {
    return _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection('fuelEntries')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FuelEntry.fromJson(doc.data()))
          .toList();
    });
  }
}
