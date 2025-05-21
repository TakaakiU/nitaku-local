import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/logger.dart';
import '../../authentication/providers/user_provider.dart';
import '../controllers/project_lists_controller.dart';
import '../models/project_lists_model.dart';
import '../widgets/project_list_item.dart';
import '../widgets/pager.dart';
import 'project_lists_detail_dialog.dart';
import '../../ranking/views/pairwise_comparison_screen.dart';

class RankingProjectListScreen extends ConsumerStatefulWidget {
  const RankingProjectListScreen({super.key});

  @override
  ConsumerState<RankingProjectListScreen> createState() => _RankingProjectListScreenState();
}

class _RankingProjectListScreenState extends ConsumerState<RankingProjectListScreen> {
  final RankingController _controller = RankingController();
  int _selectedLimit = 10;
  int _currentPage = 1;
  List<RankingProjectModel> _myProjects = [];
  List<RankingProjectModel> _otherProjects = [];
  int _otherProjectsTotal = 0;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    final user = ref.read(userProvider);
    final createdBy = user?.uid?? '';
    final allProjects = await _controller.fetchProjects();

    setState(() {
      _myProjects = allProjects.where((p) => p.createdBy == createdBy).toList();
      _otherProjects = allProjects.where((p) => p.createdBy != createdBy).toList();
      _otherProjectsTotal = _otherProjects.length;
    });

    // デバッグ用
    logInfo('_myProjects: ${_myProjects.length}件, _otherProjects: ${_otherProjects.length}件');
  }

  @override
  Widget build(BuildContext context) {
    // 余白を設定
    final size = MediaQuery.of(context).size;
    final verticalSpace = size.height * 0.03;
    // 1ページの表示数の設定
    final limits = [5, 10, 20, 50];
    // 他ユーザーのテーマをページングする設定
    final startIdx = (_currentPage - 1) * _selectedLimit;
    final endIdx = (_currentPage * _selectedLimit).clamp(0, _otherProjects.length);
    final pagedOtherProjects = _otherProjects.sublist(
      startIdx,
      endIdx,
    );

    return Scaffold(
      appBar: AppBar(title: Text('テーマ一覧')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 件数選択
          Row(
            children: [
              Text('表示件数:'),
              SizedBox(width: verticalSpace),
              DropdownButton<int>(
                value: _selectedLimit,
                items: limits
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v件')))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      _selectedLimit = v;
                      _currentPage = 1;
                    });
                  }
                },
              ),
            ],
          ),
          SizedBox(width: verticalSpace),
          Divider(),
          SizedBox(width: verticalSpace),
          // 自分のテーマ
          if (_myProjects.isNotEmpty) ...[
            Text('じぶんが作ったテーマ', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._myProjects.map((p) => ProjectListItem(
                  project: p,
                  onDetail: () => _showDetail(context, p),
                  onCreate: () => _goToPairwiseComparison(context, p),
                )),
          ],
          SizedBox(width: verticalSpace),
          // 他ユーザーのテーマ
          Text('みんなが作ったテーマ', style: TextStyle(fontWeight: FontWeight.bold)),
          ...pagedOtherProjects.map((p) => ProjectListItem(
                project: p,
                onDetail: () => _showDetail(context, p),
                onCreate: () => _goToPairwiseComparison(context, p),
              )),
          SizedBox(width: verticalSpace),
          Divider(),
          SizedBox(width: verticalSpace),
          // ページャー
          if (_otherProjectsTotal > _selectedLimit)
            Pager(
              currentPage: _currentPage,
              totalItems: _otherProjectsTotal,
              itemsPerPage: _selectedLimit,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, RankingProjectModel project) {
    showDialog(
      context: context,
      builder: (_) => ProjectDetailDialog(project: project),
    );
  }

  void _goToPairwiseComparison(BuildContext context, RankingProjectModel project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PairwiseComparisonScreen(project: project),
      ),
    );
  }
}