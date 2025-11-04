import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/data/models/user_model.dart';
import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
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
        data: {'username': username, 'password': password}
      );
      final data = response.data['data'];

      await TokenHolder.saveTokens(
        accessToken: data['tokens']['accessToken'],
        refreshToken: data['tokens']['refreshToken']
      );

      await connect();
      
      return await getProfile();
    } on DioException catch (e) {
      throw Exception('Login gagal: ${e.message}');
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
        bio: data['bio']
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
        data: {'refreshToken': refreshToken}
      );
      final data = response.data['data'];

      await TokenHolder.saveTokens(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken']
      );

      return await getProfile();
    } on DioException catch (e) {
      throw Exception('Refresh token gagal: ${e.message}');
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
        bio: data['bio']
      ).toEntity();
    } on DioException catch (e) {
      throw Exception('Gagal mendapatkan profil: ${e.message}');
    }
  }
}
