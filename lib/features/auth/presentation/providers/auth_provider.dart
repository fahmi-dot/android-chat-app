import 'dart:async';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/domain/entities/token.dart';
import 'package:android_chat_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:android_chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:android_chat_app/features/auth/domain/usecases/resend_code_usecase.dart';
import 'package:android_chat_app/features/auth/domain/usecases/verify_usecase.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_chat_app/features/auth/domain/usecases/check_usecase.dart';
import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:android_chat_app/features/auth/data/repositories/auth_repository_impl.dart';
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
  final authRepository = ref.watch(authRepositoryProvider);

  return LoginUseCase(authRepository);
});

final forgotPasswordUseCaseProvide = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return ForgotPasswordUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return RegisterUseCase(repository);
});

final resendCodeUseCaseProvider = Provider<ResendCodeUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  
  return ResendCodeUseCase(repository);
});

final verifyUseCaseProvider = Provider<VerifyUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return VerifyUseCase(authRepository);
});

final checkUseCaseProvider = Provider<CheckUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return CheckUsecase(authRepository);
});

final authProvider = AsyncNotifierProvider<AuthNotifier, Token?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<Token?> {
  @override
  FutureOr<Token?> build() async {
    return await ref.read(checkUseCaseProvider).execute();
  }

  Future<bool> login(String username, String password) async {
    state = const AsyncLoading();

    try {
      if (username.isEmpty || password.isEmpty) {
        throw Exception('Please enter username and password');
      }

      final token = await ref
          .read(loginUseCaseProvider)
          .execute(username, password);

      state = AsyncData(token);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = const AsyncLoading();

    try {
      if (email.isEmpty) throw Exception('Please enter email');

      await ref.read(forgotPasswordUseCaseProvide).execute(email);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> register(
    String phoneNumber,
    String email,
    String password,
    String cPassword,
  ) async {
    state = AsyncLoading();

    try {
      if (phoneNumber.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          cPassword.isEmpty) {
        throw Exception('Please fill in all fields');
      }

      if (password != cPassword) {
        throw Exception('Confirm password must match the password');
      }

      await ref
          .read(registerUseCaseProvider)
          .execute(phoneNumber, email, password);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> resendCode(String phoneNumber) async {
    state = AsyncLoading();

    try {
      await ref.read(resendCodeUseCaseProvider).execute(phoneNumber);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> verify(
    String phoneNumber,
    String verificationCode,
    String password,
  ) async {
    state = AsyncLoading();

    try {
      final token = await ref
          .read(verifyUseCaseProvider)
          .execute(phoneNumber, verificationCode, password);

      state = AsyncData(token);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> setUsername(String username) async {
    state = AsyncLoading();

    try {
      await ref
          .read(setProfileUseCaseProvider)
          .execute(username, null, null);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await TokenHolder.deleteTokens();
      ref.read(wsClientProvider).disconnect();

      state = AsyncData(null);
    } catch (e, trace) {
      state = AsyncError(e, trace); 
    }
  }
}
