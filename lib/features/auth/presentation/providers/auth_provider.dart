import 'dart:async';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:android_chat_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:android_chat_app/features/auth/domain/entities/auth.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:android_chat_app/features/auth/domain/usecases/login_usecase.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final apiClient = ApiClient();
  return apiClient;
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return AuthRemoteDataSourceImpl(api: api);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.read(authRemoteDatasourceProvider);
  return AuthRepositoryImpl(authRemoteDataSource: datasource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final authProvider = AsyncNotifierProvider<AuthNotifier, Auth?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<Auth?> {
  late final LoginUseCase _loginUseCase;

  @override
  FutureOr<Auth?> build() async {
    _loginUseCase = ref.read(loginUseCaseProvider);

    final accessToken = await TokenHolder.getAccessToken();
    print(accessToken);

    if (accessToken != null) {
      return Auth(isLoggedIn: true);
    }

    return null;
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final user = await _loginUseCase.execute(username, password);
      state = AsyncData(user);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  void logout() {
    TokenHolder.deleteTokens();
    state = const AsyncData(null);
  }
}
