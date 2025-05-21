// lib/features/authentication/views/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/utils/logger.dart';
import '../controllers/auth_controller.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

// Webの場合は常にAppleボタンを表示し、モバイルの場合は isIOS に依存する
// bool _shouldShowAppleButton() => kIsWeb || isIOS;

class LoginScreen extends ConsumerWidget {
  final AuthController _authController = AuthController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logInfo("Building LoginScreen");
    // 余白を設定
    final size = MediaQuery.of(context).size;
    final verticalSpace = size.height * 0.03;

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
                  if (!context.mounted) return;
                  if (user != null) {
                    ref.read(userProvider.notifier).state = UserModel(
                      uid: user.uid,
                      displayName: user.displayName,
                      email: user.email,
                      photoUrl: user.photoURL,
                      isAnonymous: user.isAnonymous,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✅ Googleアカウントでログインしました: ${user.displayName}"),
                      ),
                    );
                    // メニュー画面へ推移
                    Navigator.pushReplacementNamed(context, '/menu');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("🚫 Googleアカウントでログイン失敗しました"),
                      ),
                    );
                  }
                },
                child: const Text("Googleでサインイン"),
              ),
              SizedBox(height: verticalSpace),
              // 一時的にApple認証を削除。後に開発者プログラムの登録予定
              // ElevatedButton(
              //   onPressed: () async {
              //     final user = await _authController.signInWithApple();
              //     if (!context.mounted) return;
              //     if (user != null) {
              //       ref.read(userProvider.notifier).state = UserModel(
              //         uid: user.uid,
              //         displayName: user.displayName,
              //         email: user.email,
              //         photoUrl: user.photoURL,
              //         isAnonymous: user.isAnonymous,
              //       );
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text("✅ Appleアカウントでログインしました: ${user.displayName ?? user.email ?? user.uid}"),
              //         ),
              //       );
              //       // メニュー画面へ推移
              //       Navigator.pushReplacementNamed(context, '/menu');
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Text("🚫 Appleアカウントでログイン失敗しました"),
              //         ),
              //       );
              //     }
              //   },
              //   child: const Text("Appleでサインイン"),
              // ),
              // SizedBox(height: verticalSpace),
              ElevatedButton(
                onPressed: () async {
                  final user = await _authController.signInAnonymously();
                  if (!context.mounted) return;
                  if (user != null) {
                    ref.read(userProvider.notifier).state = UserModel(
                      uid: user.uid,
                      displayName: 'ゲスト',
                      email: user.email,
                      photoUrl: user.photoURL,
                      isAnonymous: user.isAnonymous,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("✅ ゲストでログインしました: ${user.uid}"),
                      ),
                    );
                    // メニュー画面へ推移
                    Navigator.pushReplacementNamed(context, '/menu');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("🚫 ゲストでのログインが失敗しました"),
                      ),
                    );
                  }
                },
                child: const Text("ゲストで入る"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
