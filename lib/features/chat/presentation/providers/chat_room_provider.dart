import 'dart:async';

import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_room_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final apiClient = ApiClient();
  return apiClient;
});

final chatRoomRemoteDataSourceProvider = Provider<ChatRoomRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return ChatRoomRemoteDataSourceImpl(api: api);
});

final chatRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final datasource = ref.read(chatRoomRemoteDataSourceProvider);
  return ChatRoomRepositoryImpl(chatRoomRemoteDataSource: datasource);
});

final getChatRoomUseCaseProvider = Provider<GetChatRoomUseCase>((ref) {
  final repository = ref.read(chatRepositoryProvider);
  return GetChatRoomUseCase(repository);
});

final chatRoomProvider = AsyncNotifierProvider.family<ChatRoomNotifier, List<ChatRoom>?, String>(
  ChatRoomNotifier.new
);

class ChatRoomNotifier extends AsyncNotifier<List<ChatRoom>?> {
  late final GetChatRoomUseCase _getChatRoomUseCase;
  final String roomId;

  ChatRoomNotifier(this.roomId);

  @override
  FutureOr<List<ChatRoom>?> build() async {
    _getChatRoomUseCase = ref.read(getChatRoomUseCaseProvider);
    return await _getChatRoomUseCase.execute(roomId);
  }

  Future<void> getMessages() async {
    state = const AsyncLoading();
    try {
      final chatList = await _getChatRoomUseCase.execute(roomId);
      state = AsyncData(chatList);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}