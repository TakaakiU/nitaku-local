import 'package:flutter/material.dart';
import '../models/project_input_model.dart';
import 'project_confirm_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _hasImage = false;
  List<TextEditingController> _itemControllers = [];

  @override
  void initState() {
    super.initState();
    _itemControllers = List.generate(3, (_) => TextEditingController());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addItemField() {
    setState(() {
      _itemControllers.add(TextEditingController());
    });
  }

  void _goToConfirm() {
    if (!_formKey.currentState!.validate()) return;
    final itemTitles = _itemControllers.map((c) => c.text.trim()).toList();
    // 1～3は必須
    if (itemTitles.take(3).any((t) => t.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('1 ～ 3件目の評価対象は必須です')),
      );
      return;
    }
    // 4件目以降は空でもOK、空欄は除外
    final filteredItems = itemTitles.where((t) => t.isNotEmpty).toList();
    final input = ProjectInputModel(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      hasImage: _hasImage,
      itemTitles: filteredItems,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProjectConfirmScreen(input: input),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 余白を設定
    final size = MediaQuery.of(context).size;
    final verticalSpace = size.height * 0.03;

    return Scaffold(
      appBar: AppBar(title: Text('テーマをつくる')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'テーマタイトル'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'タイトルを入力してください' : null,
              ),
              SizedBox(height: verticalSpace),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: '説明（任意）'),
                maxLines: 2,
              ),
              SizedBox(height: verticalSpace),
              Row(
                children: [
                  Checkbox(
                    value: _hasImage,
                    onChanged: null, // 今は固定でテキストのみ
                  ),
                  Text('画像付きテーマ（現在はチェック不可でテキストのみ）'),
                ],
              ),
              SizedBox(height: verticalSpace),
              Text('評価対象（1 ～ 3件目は必須で4件目以降は任意。）'),
              ..._itemControllers.asMap().entries.map((entry) {
                final idx = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'その${idx + 1}'),
                    validator: (value) {
                      if (idx < 3) {
                        return value == null || value.trim().isEmpty ? '入力してください' : null;
                      }
                      return null; // 4件目以降は任意
                    },
                  ),
                );
              }),
              SizedBox(height: verticalSpace),
              ElevatedButton(
                onPressed: _addItemField,
                child: Text('評価対象を追加'),
              ),
              SizedBox(height: verticalSpace),
              ElevatedButton(
                onPressed: _goToConfirm,
                child: Text('確認画面へ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}