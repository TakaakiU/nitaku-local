// views/ranking_screen.dart

import 'package:flutter/material.dart';
import '../../project_lists/models/project_lists_model.dart';
import '../services/pairwise_comparison_service.dart';

class RankingScreen extends StatelessWidget {
  final RankingProjectModel project;
  final Map<String, int> scores;
  
  const RankingScreen({super.key, required this.project, required this.scores});

  @override
  Widget build(BuildContext context) {
    // スコアMapをもとにランキング順に並べ替え
    final rankingList = PairwiseComparisonService.computeRanking(project.items, scores);

    return Scaffold(
      appBar: AppBar(title: Text('ランキング')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: rankingList.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final item = rankingList[index];
          final score = scores[item.itemId] ?? 0;
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(item.title),
            trailing: Text('Score: $score'),
          );
        },
      ),
    );
  }
}
