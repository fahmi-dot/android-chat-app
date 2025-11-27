import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';

abstract class UserRepository {
  Future<User> setMyProfile(String? username, String? displayName, String? password);
  Future<User> getMyProfile();
  Future<UserSummary> getUserProfile(String username);
  Future<List<UserSummary>> searchUser(String key);
}