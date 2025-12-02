import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:android_chat_app/features/chat/data/models/local/message_local_model.dart';

class SqliteService {
  Database? _db;
  String msgTable = 'messages';

  Future<Database> get db async {
    if (_db != null) return _db!;

    return await _init();
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hello.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $msgTable(
            id TEXT PRIMARY KEY,
            roomId TEXT,
            content TEXT,
            mediaUrl TEXT,
            localMediaPath TEXT,
            sentAt TEXT,
            isRead INTEGER,
            senderId TEXT,
            isSentByMe INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertMessage(MessageLocalModel message) async {
    final database = await db;
    await database.insert(
      msgTable, 
      message.toJson(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<MessageLocalModel>> getMessages(String roomId, {int limit = 100, int offset = 0}) async {
    final database = await db;
    final data = await database.query(
      msgTable, 
      where: 'roomId = ?', 
      whereArgs: [roomId]
    );
    
    return data.map((d) => MessageLocalModel.fromJson(d)).toList();
  }

  Future<void> deleteAll() async {
    final database = await db;
    await database.delete(msgTable);
  }
}