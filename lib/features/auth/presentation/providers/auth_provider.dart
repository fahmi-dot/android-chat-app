import 'dart:async';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:android_chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:android_chat_app/features/auth/domain/usecases/verify_usecase.dart';
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

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final verifyUseCaseProvider = Provider<VerifyUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyUseCase(repository);
});

final checkUseCaseProvider = Provider<CheckUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckUsecase(repository);
});

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    return await ref.read(checkUseCaseProvider).execute();
  }

  Future<bool> login(String username, String password) async {
    state = const AsyncLoading();

    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Please enter username and password');
      }

      final user = await ref
          .read(loginUseCaseProvider)
          .execute(username, password);

      state = AsyncData(user);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> register(
    String phoneNumber,
    String email,
    String username,
    String password,
    String cPassword,
  ) async {
    state = AsyncLoading();

    try {
      if (phoneNumber.isEmpty ||
          email.isEmpty ||
          username.isEmpty ||
          password.isEmpty ||
          cPassword.isEmpty) {
        throw Exception('Please fill in all fields');
      }

      await ref
          .read(registerUseCaseProvider)
          .execute(phoneNumber, email, username, password);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> verify(String phoneNumber, String verificationCode) async {
    state = AsyncLoading();

    try {
      await ref
          .read(verifyUseCaseProvider)
          .execute(phoneNumber, verificationCode);

      state = AsyncData(null);
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
