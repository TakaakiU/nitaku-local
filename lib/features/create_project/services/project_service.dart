import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class ProjectService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createProject(ProjectModel project) async {
    await _firestore.collection('projects').doc(project.projectId).set(project.toMap());
  }

  Future<void> updateProject(ProjectModel project) async {
    await _firestore.collection('projects').doc(project.projectId).update(project.toMap());
  }

  Future<void> logicalDeleteProject(String projectId, {String? deletedBy}) async {
    await _firestore.collection('projects').doc(projectId).update({
      'isDeleted': true,
      'deletedAt': DateTime.now().toIso8601String(),
      'deletedBy': deletedBy,
    });
  }

  Future<void> addItem(ItemModel item) async {
    await _firestore
        .collection('project_items')
        .doc(item.itemId)
        .set(item.toMap());
  }
}