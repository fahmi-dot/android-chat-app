import 'dart:async';
import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';
import 'package:android_chat_app/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return GetUserProfileUseCase(repository);
});

final userDetailProvider = AsyncNotifierProvider.autoDispose<UserDetailNotifier, UserSummary?>(
  UserDetailNotifier.new,
);

class UserDetailNotifier extends AsyncNotifier<UserSummary?> {

  @override
  FutureOr<UserSummary?> build() {
    return null;
  }

  Future<void> getUserProfile(String query) async {
    state = AsyncLoading();

    try {
      final user = await ref
          .read(getUserProfileUseCaseProvider)
          .execute(query);

      state = AsyncData(user);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
