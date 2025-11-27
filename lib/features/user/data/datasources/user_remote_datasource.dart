import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/user/data/models/user_model.dart';
import 'package:android_chat_app/features/user/data/models/user_summary_model.dart';
import 'package:dio/dio.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> setMyProfile(
    String? username,
    String? displayName,
    String? password,
  );
  Future<UserModel> getMyProfile();
  Future<UserSummaryModel> getUserProfile(String username);
  Future<List<UserSummaryModel>> searchUser(String key);
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final ApiClient api;

  UserRemoteDataSourceImpl({
    required this.api,
  });

  @override
  Future<UserModel> setMyProfile(
    String? username,
    String? displayName,
    String? password,
  ) async {
    final user = await getMyProfile();
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

      return await getMyProfile();
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
  Future<UserModel> getMyProfile() async {
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
    } on DioException {
      throw Exception(AppStrings.noAccountMessage);
    }
  }

  @override
  Future<UserSummaryModel> getUserProfile(String username) async {
    try {
      final response = await api.get('/user/profile?query=$username');
      final data = response.data['data'];

      return UserSummaryModel(
        username: data['username'], 
        displayName: data['displayName'], 
        avatarUrl: data['avatarUrl'],
      );
    } on DioException {
      throw Exception("User not found");
    }
  }

  @override
  Future<List<UserSummaryModel>> searchUser(String key) async {
    try {
      final response = await api.get('/user/search?query=$key');
      final data = response.data['data'] as List?;

      return data?.map((user) {
        return UserSummaryModel(
          username: user['username'], 
          displayName: user['displayName'], 
          avatarUrl: user['avatarUrl'],
        );
      })
      .toList() ?? [];
    } on DioException {
      return [];
    }
  }
}