import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/data/models/auth_model.dart';
import 'package:android_chat_app/features/auth/domain/entities/auth.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<Auth> login(String username, String password);
  Future<Auth> check();
  Future<Auth> refresh();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;

  AuthRemoteDataSourceImpl({required this.api});

  @override
  Future<Auth> login(String username, String password) async {
    final response = await api.post(
      '/auth/login',
      data: {'username': username, 'password': password}
    );

    final data = response.data['data'];

    await TokenHolder.saveTokens(
      accessToken: data['tokens']['accessToken'],
      refreshToken: data['tokens']['refreshToken']
    );

    return AuthModel(isLoggedIn: data != null).toEntity();
  }
  
  @override
  Future<Auth> check() async {
    try {
      final response = await api.get('/user');

      final data = response.data['data'];

      return (data != null)
        ? AuthModel(isLoggedIn: data != null).toEntity()
        : refresh();
    } on DioException {
      return refresh();
    }
  }

  @override
  Future<Auth> refresh() async {
    final refreshToken = await TokenHolder.getRefreshToken();

    final response = await api.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken}
    );

    final data = response.data['data'];

    await TokenHolder.saveTokens(
      accessToken: data['accessToken'],
      refreshToken: data['refreshToken']
    );

    return AuthModel(isLoggedIn: data != null).toEntity();
  }
}
