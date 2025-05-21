import 'package:flutter/material.dart';
import '../models/project_lists_model.dart';

class PairwiseComparisonScreen extends StatelessWidget {
  final RankingProjectModel project;
  const PairwiseComparisonScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // project.items からペアワイズ比較ロジックを実装
    return Scaffold(
      appBar: AppBar(title: Text('${project.title}のペアワイズ比較')),
      body: ListView(
        children: [
          ..._buildPairwiseList(project.items),
        ],
      ),
    );
  }

  List<Widget> _buildPairwiseList(List<ProjectItemModel> items) {
    List<Widget> pairs = [];
    for (int i = 0; i < items.length; i++) {
      for (int j = i + 1; j < items.length; j++) {
        pairs.add(
          ListTile(
            title: Text('${items[i].title} vs ${items[j].title}'),
            // 比較ボタンや選択UIをここに追加
          ),
        );
      }
    }
    return pairs;
  }
}