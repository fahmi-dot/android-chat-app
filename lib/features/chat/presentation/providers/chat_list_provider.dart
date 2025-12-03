import 'dart:async';

import 'package:android_chat_app/features/chat/data/datasources/local/chat_list_local_datasource.dart';
import 'package:android_chat_app/shared/providers/local_provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/chat/data/datasources/remote/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_list_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/room.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_rooms_usecase.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_room_provider.dart';
import 'package:android_chat_app/shared/providers/client_provider.dart';

final wsMessageStreamProvider = StreamProvider.autoDispose<dynamic>((ref) {
  return ref.read(wsClientProvider).messageStream;
});

final chatListRemoteDataSourceProvider = Provider<ChatListRemoteDataSource>((
  ref,
) {
  final api = ref.read(apiClientProvider);

  return ChatListRemoteDataSourceImpl(api: api);
});

final chatListLocalDataSourceProvider = Provider<ChatListLocalDataSource>((
  ref,
) {
  final hive = ref.read(hiveServiceProvider);
  final sqlite = ref.read(sqliteServiceProvider);

  return ChatListLocalDataSourceImpl(hive, sqlite);
});

final chatListRepositoryProvider = Provider<ChatListRepository>((ref) {
  final remoteDatasource = ref.watch(chatListRemoteDataSourceProvider);
  final localDatasource = ref.watch(chatListLocalDataSourceProvider);

  return ChatListRepositoryImpl(
    chatListRemoteDataSource: remoteDatasource,
    chatListLocalDataSource: localDatasource,
  );
});

final getChatRoomsUseCaseProvider = Provider<GetChatRoomsUseCase>((ref) {
  final repository = ref.watch(chatListRepositoryProvider);

  return GetChatRoomsUseCase(repository, ref);
});

final chatListProvider =
    AsyncNotifierProvider.autoDispose<ChatListNotifier, List<Room>?>(
      ChatListNotifier.new,
    );

class ChatListNotifier extends AsyncNotifier<List<Room>?> {
  @override
  FutureOr<List<Room>?> build() async {
    await ref.read(checkUseCaseProvider).execute();
    final rooms = await ref.read(getChatRoomsUseCaseProvider).execute();

    ref.listen<AsyncValue<dynamic>>(wsMessageStreamProvider, (previous, next) {
      next.whenData((data) {
        final type = data['type'];

        if (type == 'new_room') {
          _handleNewRoom(data);
        } else if (type == 'new_message') {
          _handleNewMessage(data);
        }
      });
    });

    rooms.sort((a, b) => b.lastMessageSentAt.compareTo(a.lastMessageSentAt));
    return rooms;
  }

  void _handleNewRoom(dynamic data) async {
    try {
      final roomId = data['roomId'];
      final content = data['content'];
      final sentAtStr = data['sentAt'] as String?;
      final senderId = data['senderId'];

      if (roomId == null || content == null || senderId == null) return;

      final sentAt = sentAtStr != null
          ? DateTime.parse(sentAtStr)
          : DateTime.now();

      final rooms = state.value;
      if (rooms == null) return;

      final exists = rooms.any((room) => room.id == roomId);
      final room = rooms.firstWhereOrNull((room) => room.id == roomId);

      if (!exists) {
        final newRoom = Room(
          id: roomId,
          username: room!.username,
          displayName: room.displayName,
          avatarUrl: room.avatarUrl,
          lastMessage: content,
          lastMessageSentAt: sentAt,
          unreadMessagesCount: 1,
        );

        state = AsyncData([newRoom, ...rooms]);
      } else {
        _handleNewMessage(data);
      }
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  void _handleNewMessage(dynamic data) {
    try {
      final roomId = data['roomId'];
      final content = data['content'];
      final sentAtStr = data['sentAt'] as String?;
      final senderId = data['senderId'];

      if (roomId == null || content == null || senderId == null) return;

      final sentAt = sentAtStr != null
          ? DateTime.parse(sentAtStr)
          : DateTime.now();

      final rooms = state.value;
      if (rooms == null) return;

      final updatedRooms = rooms.map((room) {
        if (room.id == roomId) {
          return room.copyWith(
            lastMessage: content,
            lastMessageSentAt: sentAt,
            unreadMessagesCount: room.unreadMessagesCount + 1,
          );
        }

        return room;
      }).toList();

      state = AsyncData(updatedRooms);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  Future<void> getRooms() async {
    state = const AsyncLoading();

    try {
      final rooms = await ref.read(getChatRoomsUseCaseProvider).execute();

      state = AsyncData(rooms);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }

  Future<void> markAsRead(String roomId) async {
    try {
      await ref.read(chatRoomProvider(roomId).notifier).markAsRead();

      state.whenData((rooms) {
        if (rooms == null) return;

        final updatedRooms = rooms.map((room) {
          if (room.id == roomId) {
            return room.copyWith(unreadMessagesCount: 0);
          }

          return room;
        }).toList();

        state = AsyncData(updatedRooms);
      });
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
}
