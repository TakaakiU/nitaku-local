import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';
import '../services/project_service.dart';

class ProjectController {
  final ProjectService _service = ProjectService();

  Future<void> createProjectWithItems({
    required String title,
    String? description,
    bool hasImage = false,
    String? createdBy,
    required List<String> itemTitles,
    List<String?>? itemImageUrls,
  }) async {
    final now = DateTime.now();
    final projectId = const Uuid().v4();
    final project = ProjectModel(
      projectId: projectId,
      title: title,
      description: description,
      hasImage: hasImage,
      isDeleted: false,
      createdAt: now,
      createdBy: createdBy,
      updatedAt: now,
      updatedBy: createdBy,
      deletedAt: null,
      deletedBy: null,
    );
    await _service.createProject(project);

    // Firestore 上の 'projects' コレクション内の対象プロジェクトのドキュメントへの
    // DocumentReference を作成し、projectRef に代入
    final DocumentReference projectRef =
        FirebaseFirestore.instance.collection('projects').doc(projectId);
    for (int i = 0; i < itemTitles.length; i++) {
      final item = ItemModel(
        itemId: const Uuid().v4(),
        projectRef: projectRef,
        title: itemTitles[i],
        imageUrl: itemImageUrls != null ? itemImageUrls[i] : null,
      );
      await _service.addItem(item);
    }
  }
}