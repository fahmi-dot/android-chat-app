import 'package:android_chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<User> setMyProfile(String id, String? username, String? displayName, String? password) async {
    final userModel = await userRemoteDataSource.setMyProfile(id, username, displayName, password);

    return userModel.toEntity();
  }

  @override
  Future<User> getMyProfile() async {
    final userModel = await userRemoteDataSource.getMyProfile();

    return userModel.toEntity();
  }

  @override
  Future<UserSummary> getUserProfile(String username) async {
    final userSummaryModel = await userRemoteDataSource.getUserProfile(username);

    return userSummaryModel.toEntity();
  }
  
  @override
  Future<List<UserSummary>> searchUser(String key) async {
    final userSummaryModels = await userRemoteDataSource.searchUser(key);
    
    return userSummaryModels.map((user) => user.toEntity()).toList();
  }
}