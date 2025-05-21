import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_lists_model.dart';

class RankingController {
  final _firestore = FirebaseFirestore.instance;

  Future<List<RankingProjectModel>> fetchProjects() async {
    final projectSnapshot = await _firestore
        .collection('projects')
        .where('isDeleted', isEqualTo: false)
        .get();

    List<RankingProjectModel> projects = [];

    for (final doc in projectSnapshot.docs) {
      final data = doc.data();

      // ユーザー名を取得
      final uid = data['createdBy'] ?? '';

      String displayName = 'ゲスト';
      if (uid.isNotEmpty) {
        // final userDoc =
        //   await _firestore.collection('users').doc(uid).get();
        final userSnapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

        if (userSnapshot.docs.isNotEmpty) {
          final data = userSnapshot.docs.first.data();
          displayName = data['displayName'] ?? 'ゲスト';
        }
      }

      // 評価対象の情報取得
      final itemsSnapshot = await _firestore
          .collection('project_items')
          .where('projectRef', isEqualTo: doc.reference)
          .get();

      final items = itemsSnapshot.docs.map((itemDoc) {
        final item = itemDoc.data();
        return ProjectItemModel(
          itemId: itemDoc.id,
          title: item['title'] ?? '',
          imageUrl: item['imageUrl'],
        );
      }).toList();

      projects.add(RankingProjectModel(
        projectId: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        hasImage: data['hasImage'] ?? false,
        createdBy: uid,
        displayName: displayName,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
        items: items,
      ));
    }
    return projects;
  }
}