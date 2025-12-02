import 'package:android_chat_app/core/local/hive_service.dart';
import 'package:android_chat_app/core/local/sqlite_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('HiveService must be overridden in main');
});

final sqliteServiceProvider = Provider<SqliteService>((ref) {
  return SqliteService();
});