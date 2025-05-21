import 'package:logging/logging.dart';

final Logger logger = Logger('AppLogger');

void setupLogger() {
  Logger.root.level = Level.ALL; // 必要に応じて変更
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });
}

// ログ出力用ラップ関数（必要に応じて追加）
void logInfo(String message) => logger.info(message);
void logWarning(String message) => logger.warning(message);
void logError(String message) => logger.severe(message);