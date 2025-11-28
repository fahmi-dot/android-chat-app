import 'package:dio/dio.dart';

import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/user/data/models/user_model.dart';
import 'package:android_chat_app/features/user/data/models/user_summary_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> setMyProfile(
    String id,
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
    String id,
    String? username,
    String? displayName,
    String? password,
  ) async {
    try {
      final response = await api.patch(
        '/user/$id/update',
        data: {
          'username': username,
          'displayName': displayName,
          'password': password,
        },
      );
      final data = response.data['data'];

      return UserModel.fromJson(data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
        status == 409
            ? AppStrings.alreadyTakenUsernameMessage
            : AppStrings.somethingWentWrongMessage,
      );
    }
  }

  @override
  Future<UserModel> getMyProfile() async {
    try {
      final response = await api.get('/user');
      final data = response.data['data'];

      return UserModel.fromJson(data);
    } on DioException {
      throw Exception(AppStrings.somethingWentWrongMessage);
    }
  }

  @override
  Future<UserSummaryModel> getUserProfile(String username) async {
    try {
      final response = await api.get('/user/profile?query=$username');
      final data = response.data['data'];

      return UserSummaryModel.fromJson(data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
        status == 404
            ? AppStrings.notFoundUserMessage
            : AppStrings.somethingWentWrongMessage,
      );
    }
  }

  @override
  Future<List<UserSummaryModel>> searchUser(String key) async {
    try {
      final response = await api.get('/user/search?query=$key');
      final data = response.data['data'] as List?;

      return data?.map((user) =>
        UserSummaryModel.fromJson(user)
      ).toList() ?? [];
    } on DioException {
      return [];
    }
  }
}