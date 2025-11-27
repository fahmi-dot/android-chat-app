import 'dart:async';
import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';
import 'package:android_chat_app/features/user/domain/usecases/search_user_usecase.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchUserUseCaseProvider = Provider<SearchUserUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);

  return SearchUserUseCase(repository);
});

final userSearchProvider = AsyncNotifierProvider<UserSearchNotifier, List<UserSummary>>(
  UserSearchNotifier.new,
);

class UserSearchNotifier extends AsyncNotifier<List<UserSummary>> {
  Timer? _debounce;

  @override
  FutureOr<List<UserSummary>> build() {
    return [];
  }

  Future<void> searchUser(String key) async {
    if (key.isEmpty) {
      _debounce?.cancel();
      state = const AsyncData([]);
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 400), () async {
      state = const AsyncLoading();
      try {
        final users = await ref
            .read(searchUserUseCaseProvider)
            .execute(key);
        
        state = AsyncData(users);
      } catch (e, trace) {
        state = AsyncError(e, trace);
      }
    });
  }
}
