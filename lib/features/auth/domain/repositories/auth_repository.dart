import 'package:android_chat_app/features/auth/domain/entities/token.dart';

abstract class AuthRepository {
  Future<Token> login(String username, String password);
  Future<void> forgotPassword(String email);
  Future<void> register(String phoneNumber, String email, String password);
  Future<void> resendCode(String phoneNumber);
  Future<Token> verify(String phoneNumber, String verificationCode, String password);
  Future<Token?> refresh();
}