import 'package:android_chat_app/core/local/hive_service.dart';
import 'package:android_chat_app/core/local/sqlite_service.dart';

abstract class AuthLocalDataSource {
  Future<void> logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveService hiveService;
  final SqliteService sqliteService;

  AuthLocalDataSourceImpl(this.hiveService, this.sqliteService);

  @override
  Future<void> logout() async {
    await hiveService.clearBox(); 
  }
}