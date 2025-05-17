import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // flutterfire configure で生成されたファイル
import 'features/authentication/views/login_screen.dart';
import 'shared/utils/logger.dart'; // ログ出力用のユーティリティ
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 環境変数の読み込み

Future<void> main() async {
  setupLogger();
  await dotenv.load();
  // Firebase 初期化とエラーハンドリングを実施
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Web用も含むマルチプラットフォーム設定
    );
    print("Firebase initialized successfully.");
  } catch (e) {
    // Firebase 初期化失敗時の処理
    print("Firebase initialization error: $e");
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Error initializing Firebase: $e"),
          ),
        ),
      ),
    );
    return; // 初期化失敗時、アプリを通常起動しない
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building MyApp");
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto'
        ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // ログイン画面へ遷移
    );
  }
}
