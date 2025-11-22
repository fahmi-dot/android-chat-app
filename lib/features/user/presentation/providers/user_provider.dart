import 'dart:async';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:android_chat_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteDatasourceProvider = Provider<UserRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return UserRemoteDataSourceImpl(api: api);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final datasource = ref.watch(userRemoteDatasourceProvider);
  return UserRepositoryImpl(userRemoteDataSource: datasource);
});

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    return await ref.read(checkUseCaseProvider).execute();
  }

  Future<bool> setProfile(
    String? username,
    String? displayName,
    String? password,
  ) async {
    state = AsyncLoading();

    try {
      final user = await ref
          .read(setUsernameUseCaseProvider)
          .execute(username, displayName, password);

      state = AsyncData(user);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }
}
