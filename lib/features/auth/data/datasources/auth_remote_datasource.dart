import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:android_chat_app/features/auth/data/models/token_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login(String username, String password);
  Future<void> forgotPassword(String email);
  Future<void> register(String phoneNumber, String email, String password);
  Future<void> resendCode(String phoneNumber);
  Future<TokenModel> verify(
    String phoneNumber,
    String verificationCode,
    String password,
  );
  Future<TokenModel?> refresh(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;
  final WsClient ws;

  AuthRemoteDataSourceImpl({required this.api, required this.ws});

  Future<void> connect() async => ws.connect();

  @override
  Future<TokenModel> login(String username, String password) async {
    try {
      final response = await api.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      final data = response.data['data'];

      final token = TokenModel(
        access: data['tokens']['accessToken'],
        refresh: data['tokens']['refreshToken'],
      );

      await connect();

      return token;
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
  Future<TokenModel> verify(
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
  Future<TokenModel?> refresh(String refreshToken) async {
    try {
      final response = await api.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data['data'];

      final token = TokenModel(
        access: data['accessToken'],
        refresh: data['refreshToken'],
      );

      return token;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception('HTTP $status: $message');
    }
  }
}
