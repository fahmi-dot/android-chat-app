import 'package:android_chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<User> setProfile(String? username, String? displayName, String? password) async {
    final userModel = await userRemoteDataSource.setProfile(username, displayName, password);

    return userModel.toEntity();
  }

  @override
  Future<User> getProfile() async {
    final userModel = await userRemoteDataSource.getProfile();

    return userModel.toEntity();
  }
}