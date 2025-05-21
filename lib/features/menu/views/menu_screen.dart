import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/providers/user_provider.dart';
import '../../authentication/controllers/auth_controller.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザー名からようこそメッセージを設定
    final user = ref.watch(userProvider);
    final displayName = user?.displayName?? 'ゲスト';
    final welcomeMessage = 'ようこそ、$displayName さん！';

    // 余白を設定
    final size = MediaQuery.of(context).size;
    final verticalSpace = size.height * 0.03;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'サインアウト',
            onPressed: () async {
              // サインアウト処理
              await AuthController().signOut();
              // ユーザー状態をクリア
              ref.read(userProvider.notifier).state = null;
              // ログイン画面に遷移（履歴を消して遷移）
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ようこそメッセージを表示
            Text(welcomeMessage),
            SizedBox(height: verticalSpace),
            // ランキングをつくる
            ElevatedButton(
              onPressed: () {
                // ランキング画面への遷移例
                Navigator.pushNamed(context, '/ranking');
              },
              child: Text('ランキングをつくる'),
            ),
            SizedBox(height: verticalSpace),
            // テーマをかんがえる
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_project');
              },
              child: Text('テーマをかんがえる'),
            ),
            // 他のメニュー項目もここに追加
          ],
        ),
      ),
    );
  }
}