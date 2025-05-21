import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';      // 環境変数の読み込み
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';                        // flutterfire configure で生成されたファイル
import 'shared/utils/logger.dart';                     // ログ出力用のユーティリティ
import 'routes/routes.dart';

Future<void> main() async {
  setupLogger();
  await dotenv.load();
  // Firebase 初期化とエラーハンドリングを実施
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Web用も含むマルチプラットフォーム設定
    );
    logInfo("Firebase initialized successfully.");
  } catch (e) {
    // Firebase 初期化失敗時の処理
    logError("Firebase initialization error: $e");
    runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Center(
            child: Text("Error initializing Firebase: $e"),
          ),
        ),
      ),
    );
    return; // 初期化失敗時、アプリを通常起動しない
  }
  
  runApp(
    ProviderScope(
      child: const MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logInfo("Building MyApp");
    return MaterialApp(
      title: 'NITAKU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto'
        ),
      debugShowCheckedModeBanner: false,
      // ルーティング設定をここで追加
      routes: appRoutes,
      initialRoute: '/login', // 初期画面
    );
  }
}
