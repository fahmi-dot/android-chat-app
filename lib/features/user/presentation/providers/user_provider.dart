import 'dart:async';
import 'package:android_chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:android_chat_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';
import 'package:android_chat_app/features/user/domain/usecases/get_profile_usecase.dart';
import 'package:android_chat_app/features/user/domain/usecases/set_profile_usecase.dart';
import 'package:android_chat_app/shared/providers/client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRemoteDatasourceProvider = Provider<UserRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);

  return UserRemoteDataSourceImpl(api: api);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final datasource = ref.watch(userRemoteDatasourceProvider);
  
  return UserRepositoryImpl(userRemoteDataSource: datasource);
});

final setProfileUseCaseProvider = Provider<SetProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return SetProfileUseCase(repository);
});

final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return GetProfileUseCase(repository);
});

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User?> {

  @override
  FutureOr<User?> build() async {
    return ref.read(getProfileUseCaseProvider).execute();
  }

  Future<bool> getProfile() async {
    state = AsyncLoading();

    try {
      final user = await ref
          .read(getProfileUseCaseProvider)
          .execute();

      state = AsyncData(user);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> setProfile(
    String? username,
    String? displayName,
    String? password,
  ) async {
    state = AsyncLoading();

    try {
      await ref
          .read(setProfileUseCaseProvider)
          .execute(username, displayName, password);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }
}
