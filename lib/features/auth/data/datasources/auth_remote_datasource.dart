import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/data/models/user_model.dart';
import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
  Future<void> register(
    String phoneNumber,
    String email,
    String username,
    String password,
  );
  Future<void> verify(String phoneNumber, String verificationCode);
  Future<User?> check();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;
  final WsClient ws;

  AuthRemoteDataSourceImpl({required this.api, required this.ws});

  Future<void> connect() async => ws.connect();

  @override
  Future<User> login(String username, String password) async {
    try {
      final response = await api.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data['data'];

      await TokenHolder.saveTokens(
        accessToken: data['tokens']['accessToken'],
        refreshToken: data['tokens']['refreshToken'],
      );

      await connect();

      return await getProfile();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
        status == 401 ? AppStrings.invalidMessage : AppStrings.noAccountMessage,
      );
    }
  }

  @override
  Future<void> register(
    String phoneNumber,
    String email,
    String username,
    String password,
  ) async {
    try {
      await api.post(
        '/auth/register',
        data: {
          'username': username,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
        },
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception(
        message == 'Username is already taken.'
            ? AppStrings.takenMessage
            : AppStrings.registeredMessage,
      );
    }
  }

  @override
  Future<void> verify(String phoneNumber, String verificationCode) async {
    try {
      await api.post(
        '/auth/verify',
        data: {
          'phoneNumber': phoneNumber,
          'verificationCode': verificationCode,
        },
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
        status == 401
            ? AppStrings.invalidCodeMessage
            : AppStrings.expiredMessage,
      );
    }
  }

  @override
  Future<User?> check() async {
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
      ).toEntity();
    } on DioException {
      return await refresh();
    }
  }

  Future<User?> refresh() async {
    try {
      final refreshToken = await TokenHolder.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await TokenHolder.deleteTokens();
        return null;
      }

      final response = await api.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data['data'];

      await TokenHolder.saveTokens(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );

      return await getProfile();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception('HTTP $status: $message');
    }
  }

  Future<User> getProfile() async {
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
      ).toEntity();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception('HTTP $status: $message');
    }
  }
}
