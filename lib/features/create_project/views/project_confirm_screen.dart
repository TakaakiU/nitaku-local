import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/providers/user_provider.dart';
import '../controllers/project_controller.dart';
import '../models/project_input_model.dart';

class ProjectConfirmScreen extends StatefulWidget {
  final ProjectInputModel input;
  const ProjectConfirmScreen({super.key, required this.input});

  @override
  State<ProjectConfirmScreen> createState() => _ProjectConfirmScreenState();
}

class _ProjectConfirmScreenState extends State<ProjectConfirmScreen> {
  final ProjectController _controller = ProjectController();
  bool _isLoading = false;

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    // 非同期処理の前にオブジェクトを取得
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => _isLoading = true);
    try {
      // 現在のログインユーザーの uid を取得
      final user = ref.read(userProvider);
      final uid = user?.uid;

      await _controller.createProjectWithItems(
        title: widget.input.title,
        description: widget.input.description,
        hasImage: widget.input.hasImage,
        createdBy: uid,
        itemTitles: widget.input.itemTitles,
        itemImageUrls: List.filled(widget.input.itemTitles.length, null),
      );
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('🚫 テーマの作成に失敗しました: $e')),
      );
      return;
    }
    if (!mounted) return;

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('✅ テーマを作成しました')),
    );
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    navigator.pushNamedAndRemoveUntil('/menu', (route) => false);
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final input = widget.input;
    // 余白を設定
    final size = MediaQuery.of(context).size;
    final verticalSpace = size.height * 0.03;

    return Scaffold(
      appBar: AppBar(title: Text('つくる内容の確認')),
      body: Consumer(
        builder: (context, ref, _) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              Text('テーマタイトル: ${input.title}'),
              SizedBox(height: verticalSpace),
              Text('説明: ${input.description ?? "（なし）"}'),
              SizedBox(height: verticalSpace),
              Text('画像付きテーマ: ${input.hasImage ? "はい" : "いいえ"}'),
              SizedBox(height: verticalSpace),
              Text('評価対象:'),
              ...input.itemTitles.asMap().entries.map((entry) {
                final idx = entry.key;
                final title = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text('その${idx + 1}: $title'),
                );
              }),
              SizedBox(height: verticalSpace),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _submit(context, ref),
                      child: Text('確定'),
                    ),
              SizedBox(height: verticalSpace),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('戻る'),
              ),
              ],
            ),
          );
        },
      ),
    );
  }
}