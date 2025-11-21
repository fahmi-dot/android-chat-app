import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/data/models/user_model.dart';
import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
  Future<void> forgotPassword(String email);
  Future<void> register(String phoneNumber, String email, String password);
  Future<void> resendCode(String phoneNumber);
  Future<User> verify(
    String phoneNumber,
    String verificationCode,
    String password,
  );
  Future<User> setProfile(
    String? username,
    String? displayName,
    String? password,
  );
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
        status == 401
            ? AppStrings.invalidLoginMessage
            : AppStrings.noAccountMessage,
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await api.post('/auth/forgot', data: {'email': email});
    } on DioException {
      throw Exception();
    }
  }

  @override
  Future<void> register(
    String phoneNumber,
    String email,
    String password,
  ) async {
    try {
      await api.post(
        '/auth/register',
        data: {
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
        },
      );
    } on DioException {
      throw Exception(AppStrings.registeredMessage);
    }
  }

  @override
  Future<void> resendCode(String phoneNumber) async {
    try {
      await api.post('/auth/resend', data: {'phoneNumber': phoneNumber});
    } on DioException {
      throw Exception(AppStrings.failedResendMessage);
    }
  }

  @override
  Future<User> verify(
    String phoneNumber,
    String verificationCode,
    String password,
  ) async {
    try {
      final response = await api.post(
        '/auth/verify',
        data: {
          'phoneNumber': phoneNumber,
          'verificationCode': verificationCode,
        },
      );
      final data = response.data['data'];

      return login(data['username'], password);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
        status == 401
            ? AppStrings.invalidCodeMessage
            : AppStrings.expiredCodeMessage,
      );
    }
  }

  @override
  Future<User> setProfile(
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
