import 'package:android_chat_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<User?> check();
}