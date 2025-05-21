import 'package:flutter/material.dart';
import '../models/project_lists_model.dart';

class ProjectDetailDialog extends StatelessWidget {
  final RankingProjectModel project;
  const ProjectDetailDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(project.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('説明: ${project.description}'),
          Text('作成者: ${project.displayName}'),
          SizedBox(height: 8),
          Text('評価対象:'),
          ...project.items.map((item) => Text('- ${item.title}')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('閉じる'),
        ),
      ],
    );
  }
}