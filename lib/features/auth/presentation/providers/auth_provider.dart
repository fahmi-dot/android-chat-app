import 'dart:async';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/domain/usecases/check_usecase.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:android_chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:android_chat_app/features/auth/domain/usecases/login_usecase.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final wsClientProvider = Provider<WsClient>((ref) {
  return WsClient();
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  final ws = ref.read(wsClientProvider);
  return AuthRemoteDataSourceImpl(api: api, ws: ws);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(authRemoteDataSource: datasource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final checkUseCaseProvider = Provider<CheckUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckUsecase(repository);
});

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<User?> {
  late final LoginUseCase _loginUseCase;
  late final CheckUsecase _checkUsecase;

  @override
  FutureOr<User?> build() async {
    _loginUseCase = ref.read(loginUseCaseProvider);
    _checkUsecase = ref.read(checkUseCaseProvider);

    return await _checkUsecase.execute();
  }

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password must be filled in');
    }

    state = const AsyncLoading();

    try {
      final user = await _loginUseCase.execute(username, password);
      state = AsyncData(user);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<void> logout() async {
    TokenHolder.deleteTokens();
    ref.read(wsClientProvider).disconnect();
    state = const AsyncData(null);
  }
}