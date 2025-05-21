// views/pairwise_comparison_screen.dart

import 'package:flutter/material.dart';
import '../../project_lists/models/project_lists_model.dart';
import '../controllers/pairwise_comparison_controller.dart';
import 'ranking_result_screen.dart';

class PairwiseComparisonScreen extends StatefulWidget {
  final RankingProjectModel project;

  const PairwiseComparisonScreen({super.key, required this.project});

  @override
  State<PairwiseComparisonScreen> createState() => _PairwiseComparisonScreenState();

}

class _PairwiseComparisonScreenState extends State<PairwiseComparisonScreen> {
  late PairwiseComparisonController _controller;
  // 現在の選択状態："left" または "right"（未選択はnull）
  String? _selectedSide;

  /// 将来的に個々の評価対象の画像を背景として表示するための機能フラグ（現状は未使用）
  static const bool kEnableImageBackground = false;

  @override
  void initState() {
    super.initState();
    _controller = PairwiseComparisonController(items: widget.project.items);
  }

  @override
  Widget build(BuildContext context) {
    final currentPair = _controller.getCurrentPair();
    if (currentPair == null) {
      return Scaffold(
        appBar: AppBar(title: Text('比較なし')),
        body: Center(child: Text('評価対象が不足しています。')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.project.title}の二択！'),
      ),
      body: Column(
        children: [
          // 上部：進捗表示
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '進捗: ${_controller.currentPairIndex + 1} / ${_controller.totalComparisons} '
              '(${(_controller.progress * 100).toStringAsFixed(0)}%)',
              style: TextStyle(fontSize: 18),
            ),
          ),
          // 中央：左右に大きく表示
          Expanded(
            child: Row(
              children: [
                // 左側評価対象
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSide = 'left';
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: _buildBoxDecoration(
                        isSelected: _selectedSide == 'left',
                        imageUrl: currentPair.first.imageUrl,
                      ),
                      child: Center(
                        child: Text(
                          currentPair.first.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                // 右側評価対象
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSide = 'right';
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: _buildBoxDecoration(
                        isSelected: _selectedSide == 'right',
                        imageUrl: currentPair.second.imageUrl,
                      ),
                      child: Center(
                        child: Text(
                          currentPair.second.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 下部：進行ボタン（「すすむ」または最終時「ランキングを表示」）
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedSide == null
                ? null
                : () {
                  // 選択された対象のスコアを更新
                  if (_selectedSide == 'left') {
                    _controller.selectItem(currentPair.first);
                  } else if (_selectedSide == 'right') {
                    _controller.selectItem(currentPair.second);
                  }
                  // 選択状態リセット
                  setState(() {
                    _selectedSide = null;
                  });
                  // 最終ペアの場合はランキング画面へ、それ以外なら次のペアへ
                  if (_controller.isLastPair) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RankingScreen(
                          project: widget.project,
                          scores: _controller.scores,
                        ),
                      ),
                    );
                  } else {
                    setState(() {
                      _controller.moveToNextPair();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  _controller.isLastPair ? 'ランキングを表示' : 'すすむ',
                  style: TextStyle(fontSize: 18),
                ),
            ),
          ),
        ]
      ),
    );
  }

  /// 画像背景表示機能を将来的に有効化するためのBoxDecoration構築ヘルパー
  BoxDecoration _buildBoxDecoration({required bool isSelected, String? imageUrl}) {
    if (kEnableImageBackground && imageUrl != null && imageUrl.isNotEmpty) {
      return BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          // 選択時のみ色フィルターをかける例
          colorFilter: isSelected
              ? ColorFilter.mode(
                  Colors.blue.withAlpha((0.3 * 255).round()),
                  BlendMode.dstATop,
                )
              : null,
        ),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(8),
      );
    } else {
      // 現在は通常の背景色でハイライト表示
      return BoxDecoration(
        color: isSelected ? Colors.blue.withAlpha((0.3 * 255).round()) : Colors.grey[200],
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(8),
      );
    }
  }
}
