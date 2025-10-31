import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/data/models/auth_model.dart';
import 'package:android_chat_app/features/auth/domain/entities/auth.dart';

abstract class AuthRemoteDataSource {
  Future<Auth> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient api;

  AuthRemoteDataSourceImpl({required this.api});

  @override
  Future<Auth> login(String username, String password) async {
    final response = await api.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );

    final data = response.data['data'];

    await TokenHolder.saveTokens(
      accessToken: data['tokens']['accessToken'],
      refreshToken: data['tokens']['refreshToken']
    );

    return AuthModel(isLoggedIn: true).toEntity();
  }
}
