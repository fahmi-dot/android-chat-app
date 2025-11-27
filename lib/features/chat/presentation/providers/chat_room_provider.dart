import 'dart:async';
import 'package:android_chat_app/features/chat/data/datasources/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/models/message_model.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:android_chat_app/shared/providers/client_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomRemoteDataSourceProvider = Provider<ChatRoomRemoteDataSource>((
  ref,
) {
  final api = ref.read(apiClientProvider);
  return ChatRoomRemoteDataSourceImpl(api: api);
});

final chatRoomRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final datasource = ref.watch(chatRoomRemoteDataSourceProvider);
  return ChatRoomRepositoryImpl(chatRoomRemoteDataSource: datasource);
});

final getChatMessageUseCaseProvider = Provider<GetChatMessageUseCase>((ref) {
  final repository = ref.watch(chatRoomRepositoryProvider);

  return GetChatMessageUseCase(repository);
});

final chatRoomProvider = AsyncNotifierProvider.family
    .autoDispose<ChatRoomNotifier, List<Message>?, String?>(
      ChatRoomNotifier.new,
    );

class ChatRoomNotifier extends AsyncNotifier<List<Message>?> {
  final String? roomId;

  ChatRoomNotifier(this.roomId);

  @override
  FutureOr<List<Message>?> build() async {
    final user = await ref.read(userProvider.future);

    final messages = await ref
        .read(getChatMessageUseCaseProvider)
        .execute(roomId!, user!.id);

    ref.listen<AsyncValue<dynamic>>(wsMessageStreamProvider, (previous, next) {
      next.whenData((data) {
        final type = data['type'];
        final messageRoomId = data['roomId'];

        if (type == 'new_message' && messageRoomId == roomId) {
          _handleNewMessage(data, user.id);
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
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  Future<bool> sendMessage(String message, String? username) async {
    try {
      final ws = ref.read(wsClientProvider);

      ws.sendMessage(roomId: roomId, content: message, receiver: username);
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
      final messages = await ref
          .read(getChatMessageUseCaseProvider)
          .execute(roomId!, user!.id);

      state = AsyncData(messages);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
