import 'package:android_chat_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<void> register(String phoneNumber, String email, String username, String password);
  Future<User?> check();
}