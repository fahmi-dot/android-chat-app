import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/user/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> setProfile(
    String? username,
    String? displayName,
    String? password,
  );
  Future<UserModel> getProfile();
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final ApiClient api;

  UserRemoteDataSourceImpl({required this.api});

  @override
  Future<UserModel> setProfile(
    String? username,
    String? displayName,
    String? password,
  ) async {
    final user = await getProfile();
    final id = user.id;
    try {
      await api.patch(
        '/user/$id/update',
        data: {
          'username': username,
          'displayName': displayName,
          'password': password,
        },
      );

      return await getProfile();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
        status == 409
            ? AppStrings.usernameTakenMessage
            : AppStrings.noAccountMessage,
      );
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await api.get('/user');
      final data = response.data['data'];

      return UserModel(
        id: data['id'],
        username: data['username'],
        displayName: data['displayName'],
        phoneNumber: data['phoneNumber'],
        avatarUrl: data['avatarUrl'],
        bio: data['bio'],
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception('HTTP $status: $message');
    }
  }
}