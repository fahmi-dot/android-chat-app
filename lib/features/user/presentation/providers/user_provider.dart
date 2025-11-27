import 'dart:async';
import 'package:android_chat_app/features/user/data/datasources/user_remote_datasource.dart';
import 'package:android_chat_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';
import 'package:android_chat_app/features/user/domain/usecases/get_my_profile_usecase.dart';
import 'package:android_chat_app/features/user/domain/usecases/set_my_profile_usecase.dart';
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

final setMyProfileUseCaseProvider = Provider<SetMyProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return SetMyProfileUseCase(repository);
});

final getMyProfileUseCaseProvider = Provider<GetMyProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return GetMyProfileUseCase(repository);
});

final userProvider = AsyncNotifierProvider<UserNotifier, User?>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User?> {

  @override
  FutureOr<User?> build() async {
    return ref.read(getMyProfileUseCaseProvider).execute();
  }

  Future<bool> getMyProfile() async {
    state = AsyncLoading();

    try {
      final user = await ref
          .read(getMyProfileUseCaseProvider)
          .execute();

      state = AsyncData(user);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<bool> setMyProfile(
    String? username,
    String? displayName,
    String? password,
  ) async {
    state = AsyncLoading();

    try {
      await ref
          .read(setMyProfileUseCaseProvider)
          .execute(username, displayName, password);

      state = AsyncData(null);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }
}
