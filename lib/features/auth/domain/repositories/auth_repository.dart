import 'package:android_chat_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<void> register(String phoneNumber, String email, String password);
  Future<void> resendCode(String phoneNumber);
  Future<User> verify(String phoneNumber, String verificationCode, String password);
  Future<User> setProfile(String? username, String? displayName, String? password);
  Future<User?> check();
}