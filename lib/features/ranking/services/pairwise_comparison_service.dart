// services/pairwise_comparison_service.dart

import '../../project_lists/models/project_lists_model.dart';

/// 汎用のPairクラス
class Pair<T> {
  final T first;
  final T second;

  Pair(this.first, this.second);
}

/// ペアワイズ比較用のロジック群
class PairwiseComparisonService {
  /// 評価対象のリストから全組み合わせのペアを生成する
  static List<Pair<ProjectItemModel>> generateComparisonPairs(List<ProjectItemModel> items) {
    List<Pair<ProjectItemModel>> pairs = [];
    for (int i = 0; i < items.length; i++) {
      for (int j = i + 1; j < items.length; j++) {
        pairs.add(Pair(items[i], items[j]));
      }
    }
    return pairs;
  }

  /// スコアMapをもとに、スコアの高い順に評価対象を並べたランキングリストを返す
  static List<ProjectItemModel> computeRanking(
      List<ProjectItemModel> items, Map<String, int> scores) {
    List<ProjectItemModel> sortedItems = List.from(items);
    sortedItems.sort((a, b) {
      int scoreA = scores[a.itemId] ?? 0;
      int scoreB = scores[b.itemId] ?? 0;
      return scoreB.compareTo(scoreA);
    });
    return sortedItems;
  }
}
