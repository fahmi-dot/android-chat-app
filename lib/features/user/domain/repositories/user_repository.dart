import 'package:android_chat_app/features/user/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> setProfile(String? username, String? displayName, String? password);
  Future<User> getProfile();
}