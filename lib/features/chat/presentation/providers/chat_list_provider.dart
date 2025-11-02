import 'dart:async';

import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/chat/data/datasources/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_list_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_list_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final apiClient = ApiClient();
  return apiClient;
});

final chatListRemoteDataSourceProvider = Provider<ChatListRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  final authState = ref.watch(authProvider);
  final currentUsername = authState.value?.username ?? '';

  return ChatListRemoteDataSourceImpl(api: api, currentUsername: currentUsername);
});

final chatListRepositoryProvider = Provider<ChatListRepository>((ref) {
  final datasource = ref.read(chatListRemoteDataSourceProvider);
  return ChatListRepositoryImpl(chatListRemoteDataSource: datasource);
});

final getChatListUseCaseProvider = Provider<GetChatListUsecase>((ref) {
  final repository = ref.read(chatListRepositoryProvider);
  return GetChatListUsecase(repository);
});

final chatListProvider = AsyncNotifierProvider<ChatListNotifier, List<ChatList>?>(
  ChatListNotifier.new,
);

class ChatListNotifier extends AsyncNotifier<List<ChatList>?> {
  late final GetChatListUsecase _getChatListUsecase;

  @override
  FutureOr<List<ChatList>?> build() async {
    _getChatListUsecase = ref.read(getChatListUseCaseProvider);

    final auth = await ref.watch(authProvider.future);
    if (auth == null) return [];

    return await _getChatListUsecase.execute();
  }

  Future<void> list() async {
    state = const AsyncLoading();
    try {
      final chatList = await _getChatListUsecase.execute();
      state = AsyncData(chatList);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}