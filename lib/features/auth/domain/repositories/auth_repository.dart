import 'package:android_chat_app/features/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<Auth> login(String username, String password);
}