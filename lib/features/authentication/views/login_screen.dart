// lib/features/authentication/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../shared/utils/platform_util.dart'; // 先ほど作成したユーティリティファイルをインポート
import '../../../shared/utils/logger.dart';
import '../controllers/auth_controller.dart';

// Webの場合は常にAppleボタンを表示し、モバイルの場合は isIOS に依存する
bool _shouldShowAppleButton() => kIsWeb || isIOS;

class LoginScreen extends StatelessWidget {
  final AuthController _authController = AuthController();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logInfo("Building LoginScreen");
    return Scaffold(
      appBar: AppBar(
        title: const Text("ログイン"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 内容に合わせ高さを調整
            children: [
              ElevatedButton(
                onPressed: () async {
                  final user = await _authController.signInWithGoogle();
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Google ログイン成功: ${user.displayName}"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Google ログインキャンセルまたは失敗"),
                      ),
                    );
                  }
                },
                child: const Text("Googleでサインイン"),
              ),
              const SizedBox(height: 16),
              if (_shouldShowAppleButton()) ...[
                ElevatedButton(
                  onPressed: () async {
                    final user = await _authController.signInWithApple();
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Apple ログイン成功: ${user.displayName ?? user.email ?? user.uid}"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Apple ログインキャンセルまたは失敗"),
                        ),
                      );
                    }
                  },
                  child: const Text("Appleでサインイン"),
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: () async {
                  final user = await _authController.signInAnonymously();
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("匿名ログイン成功: ${user.uid}"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("匿名ログイン失敗"),
                      ),
                    );
                  }
                },
                child: const Text("ゲストログイン"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
