import 'package:flutter/material.dart';
import '../models/project_lists_model.dart';

class ProjectListItem extends StatelessWidget {
  final RankingProjectModel project;
  final VoidCallback onDetail;
  final VoidCallback onCreate;

  const ProjectListItem({
    super.key,
    required this.project,
    required this.onDetail,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(project.title),
        subtitle: Text('作成者: ${project.displayName}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: onDetail, child: Text('詳細')),
            ElevatedButton(onPressed: onCreate, child: Text('つくる')),
          ],
        ),
      ),
    );
  }
}