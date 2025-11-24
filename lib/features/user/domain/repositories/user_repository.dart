import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';

abstract class UserRepository {
  Future<User> setProfile(String? username, String? displayName, String? password);
  Future<User> getProfile();
  Future<List<UserSummary>> searchUser(String key);
}