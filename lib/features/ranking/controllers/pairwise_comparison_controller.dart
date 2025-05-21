// controller/pairwise_comparison_controller.dart

import '../../project_lists/models/project_lists_model.dart';
import '../services/pairwise_comparison_service.dart';

class PairwiseComparisonController {
  final List<Pair<ProjectItemModel>> comparisonPairs;
  int currentPairIndex = 0;
  final Map<String, int> scores = {}; // 各評価対象の得点（itemIdをキーとする）

  PairwiseComparisonController({required List<ProjectItemModel> items})
      : comparisonPairs = PairwiseComparisonService.generateComparisonPairs(items) {
    // すべての評価対象の初期スコアを0に設定
    for (var item in items) {
      scores[item.itemId] = 0;
    }
  }

  /// 現在の比較ペアを返す（存在しなければnull）
  Pair<ProjectItemModel>? getCurrentPair() {
    if (currentPairIndex < comparisonPairs.length) {
      return comparisonPairs[currentPairIndex];
    }
    return null;
  }

  /// 選択された評価対象のスコアをインクリメントする
  void selectItem(ProjectItemModel selected) {
    scores[selected.itemId] = (scores[selected.itemId] ?? 0) + 1;
  }

  /// 次のペアへ進む。現在が最後のペアの場合はfalseを返す。
  bool moveToNextPair() {
    if (currentPairIndex < comparisonPairs.length - 1) {
      currentPairIndex++;
      return true;
    }
    return false;
  }

  /// 現在が最後の比較ペアか否か
  bool get isLastPair => currentPairIndex == (comparisonPairs.length - 1);

  /// 総ペア数
  int get totalComparisons => comparisonPairs.length;

  /// 現在の進捗率（0〜1）
  double get progress => (currentPairIndex + 1) / totalComparisons;
}
