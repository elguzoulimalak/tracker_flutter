import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:tracker_flutter/features/maintenance/models/maintenance_category.dart';

class MaintenanceCategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  Future<MaintenanceCategory> addCategory({
    required String uid,
    required String name,
    String? description,
  }) async {
    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      final category = MaintenanceCategory(
        id: id,
        name: name,
        description: description,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenanceCategories')
          .doc(id)
          .set(category.toJson());

      return category;
    } catch (e) {
      rethrow;
    }
  }

  Future<MaintenanceCategory> updateCategory({
    required String uid,
    required String categoryId,
    required String name,
    String? description,
  }) async {
    try {
      final now = DateTime.now();

      final category = MaintenanceCategory(
        id: categoryId,
        name: name,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: now,
      );

      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenanceCategories')
          .doc(categoryId)
          .update(category.toJson());

      return category;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory({
    required String uid,
    required String categoryId,
  }) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenanceCategories')
          .doc(categoryId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MaintenanceCategory>> getCategories(String uid) {
    return _firestore
        .collection(_collectionPath)
        .doc(uid)
        .collection('maintenanceCategories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MaintenanceCategory.fromJson(doc.data()))
          .toList();
    });
  }

  Future<MaintenanceCategory?> getCategoryById({
    required String uid,
    required String categoryId,
  }) async {
    try {
      final doc = await _firestore
          .collection(_collectionPath)
          .doc(uid)
          .collection('maintenanceCategories')
          .doc(categoryId)
          .get();

      if (doc.exists) {
        return MaintenanceCategory.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
