import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:android_chat_app/features/chat/domain/usecases/get_room_messages_usecase.dart';
import 'package:android_chat_app/features/chat/data/datasources/local/chat_room_local_datasource.dart';
import 'package:android_chat_app/features/chat/data/datasources/remote/chat_room_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/models/remote/message_remote_model.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_room_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/message.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_room_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/mark_as_read_usecase.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';
import 'package:android_chat_app/shared/providers/client_provider.dart';
import 'package:android_chat_app/shared/providers/local_provider.dart';

final chatRoomRemoteDataSourceProvider = Provider<ChatRoomRemoteDataSource>((
  ref,
) {
  final api = ref.read(apiClientProvider);
  return ChatRoomRemoteDataSourceImpl(api: api);
});

final chatRoomLocalDataSourceProvider = Provider<ChatRoomLocalDataSource>((
  ref,
) {
  final hive = ref.read(hiveServiceProvider);
  final sqlite = ref.read(sqliteServiceProvider);

  return ChatRoomLocalDataSourceImpl(hive, sqlite);
});

final chatRoomRepositoryProvider = Provider<ChatRoomRepository>((ref) {
  final remoteDatasource = ref.watch(chatRoomRemoteDataSourceProvider);
  final localDatasource = ref.watch(chatRoomLocalDataSourceProvider);

  return ChatRoomRepositoryImpl(
    chatRoomRemoteDataSource: remoteDatasource,
    chatRoomLocalDataSource: localDatasource,
  );
});

final getRoomMessagesUseCaseProvider = Provider<GetRoomMessagesUseCase>((ref) {
  final repository = ref.watch(chatRoomRepositoryProvider);

  return GetRoomMessagesUseCase(repository);
});

final markAsReadUseCaseProvider = Provider<MarkAsReadUseCase>((ref) {
  final repository = ref.watch(chatRoomRepositoryProvider);

  return MarkAsReadUseCase(repository);
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
        .read(getRoomMessagesUseCaseProvider)
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
      final newMessage = MessageRemoteModel.fromJson(data, userId).toEntity();

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

  Future<void> markAsRead() async {
    try {
      await ref.read(markAsReadUseCaseProvider).execute(roomId!);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(userProvider.future);
      final messages = await ref
          .read(getRoomMessagesUseCaseProvider)
          .execute(roomId!, user!.id);

      state = AsyncData(messages);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
