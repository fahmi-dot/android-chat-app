import 'dart:async';

import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/models/message_model.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomRemoteDataSourceProvider = Provider<ChatRoomRemoteDataSource>((
  ref,
) {
  final api = ref.read(apiClientProvider);
  return ChatRoomRemoteDataSourceImpl(api: api);
});

final chatRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final datasource = ref.watch(chatRoomRemoteDataSourceProvider);
  return ChatRoomRepositoryImpl(chatRoomRemoteDataSource: datasource);
});

final getChatMessageUseCaseProvider = Provider<GetChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetChatMessageUseCase(repository);
});

final chatRoomProvider = AsyncNotifierProvider.family
    .autoDispose<ChatRoomNotifier, List<Message>?, String>(
      ChatRoomNotifier.new,
    );

class ChatRoomNotifier extends AsyncNotifier<List<Message>?> {
  final String roomId;

  ChatRoomNotifier(this.roomId);

  @override
  FutureOr<List<Message>?> build() async {
    final user = await ref.read(userProvider.future);
    final userId = user!.id;

    final messages = await ref
        .read(getChatMessageUseCaseProvider)
        .execute(roomId, userId);

    ref.read(wsClientProvider).subscribeToUserQueue();

    ref.listen<AsyncValue<dynamic>>(wsMessageStreamProvider, (previous, next) {
      next.whenData((data) {
        final type = data['type'];
        final messageRoomId = data['roomId'];

        if (type == 'new_message' && messageRoomId == roomId) {
          _handleNewMessage(data, userId);
          ref.read(chatListProvider.notifier).markAsRead(messageRoomId);
        }
      });
    });

    return messages;
  }

  void _handleNewMessage(dynamic data, String userId) {
    try {
      final newMessage = MessageModel.fromJson(data, userId);

      final messages = state.value;
      if (messages == null) return;

      final exists = messages.any((message) => message.id == newMessage.id);

      if (!exists) {
        state = AsyncData([newMessage, ...messages]);
      }
    } catch (e) {
      print('Failed to handle new message: $e');
    }
  }

  Future<bool> sendMessage(String message) async {
    try {
      final ws = ref.read(wsClientProvider);
      final roomDetail = await ref
          .read(getChatRoomDetailUseCaseProvider)
          .execute(roomId);

      ws.sendMessage(roomId: roomId, content: message, receiver: roomDetail.username);
      return true;
    } catch (e, trace) {
      state = AsyncError(e, trace);
      return false;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(userProvider.future);
      final userId = user!.id;
      
      final messages = await ref
          .read(getChatMessageUseCaseProvider)
          .execute(roomId, userId);

      state = AsyncData(messages);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
