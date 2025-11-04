import 'dart:async';

import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/chat/data/datasources/chat_list_remote_datasource.dart';
import 'package:android_chat_app/features/chat/data/repositories/chat_list_repository_impl.dart';
import 'package:android_chat_app/features/chat/domain/entities/chat_list.dart';
import 'package:android_chat_app/features/chat/domain/repositories/chat_list_repository.dart';
import 'package:android_chat_app/features/chat/domain/usecases/get_chat_list_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wsMessageStreamProvider = StreamProvider<dynamic>((ref) {
  final ws = ref.read(wsClientProvider);
  return ws.messageStream;
});

final chatListRemoteDataSourceProvider = Provider<ChatListRemoteDataSource>((
  ref,
) {
  final api = ref.read(apiClientProvider);
  final authState = ref.read(authProvider);
  final currentUsername = authState.value?.username ?? '';

  return ChatListRemoteDataSourceImpl(
    api: api,
    currentUsername: currentUsername,
  );
});

final chatListRepositoryProvider = Provider<ChatListRepository>((ref) {
  final datasource = ref.read(chatListRemoteDataSourceProvider);
  return ChatListRepositoryImpl(chatListRemoteDataSource: datasource);
});

final getChatListUseCaseProvider = Provider<GetChatListUseCase>((ref) {
  final repository = ref.read(chatListRepositoryProvider);
  return GetChatListUseCase(repository);
});

final chatListProvider =
    AsyncNotifierProvider<ChatListNotifier, List<ChatList>?>(
      ChatListNotifier.new,
    );

class ChatListNotifier extends AsyncNotifier<List<ChatList>?> {
  late final GetChatListUseCase _getChatListUseCase;

  @override
  FutureOr<List<ChatList>?> build() async {
    _getChatListUseCase = ref.read(getChatListUseCaseProvider);

    final authState = ref.read(authProvider).value;
    if (authState == null) return [];

    final chatList = await _getChatListUseCase.execute();
    if (chatList != null) {
      final ws = ref.read(wsClientProvider);
      for (final room in chatList) {
        ws.subscribeToRoom(room.id);
      }
    }

    ref.listen<AsyncValue<dynamic>>(
      wsMessageStreamProvider,
      (previous, next) {
        next.whenData((data) {
          final type = data['type'] as String?;
          
          if (type == 'new_chat') {
            _handleNewRoom(data);
          } else if (type == 'message') {
            _handleNewMessage(data);
          }
        });
      },
    );

    return chatList;
  }

  void _handleNewRoom(dynamic data) {
    try {
      final id = data['id'];
      final content = data['content'];
      final sentAtStr = data['sentAt'];
      final senderId = data['senderId'];
      
      if (id == null || content == null || senderId == null) {
        return;
      }

      final sentAt = sentAtStr != null 
          ? DateTime.parse(sentAtStr) 
          : DateTime.now();
      
      state.whenData((rooms) {
        if (rooms == null) return;
        
        final exists = rooms.any((room) => room.id == id);
        
        if (!exists) {
          final newRoom = ChatList(
            id: id,
            username: senderId,
            displayName: senderId,
            avatarUrl: 'url',
            lastMessage: content,
            lastMessageSentAt: sentAt,
            unreadMessagesCount: 1,
          );
          
          ref.read(wsClientProvider).subscribeToRoom(id);
          
          state = AsyncData([newRoom, ...rooms]);
        } else {
          _handleNewMessage(data);
        }
      });
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }
  
  void _handleNewMessage(dynamic data) {
    try {
      final id = data['id'] as String?;
      final content = data['content'] as String?;
      final sentAtStr = data['sentAt'] as String?;
      
      if (id == null || content == null) {
        return;
      }

      final sentAt = sentAtStr != null 
          ? DateTime.parse(sentAtStr) 
          : DateTime.now();
      
      state.whenData((rooms) {
        if (rooms == null) return;
        
        final updatedChats = rooms.map((room) {
          if (room.id == id) {
            return room.copyWith(
              lastMessage: content,
              lastMessageSentAt: sentAt,
              unreadMessagesCount: room.unreadMessagesCount + 1,
            );
          }
          return room;
        }).toList();
        
        updatedChats.sort((a, b) => 
          b.lastMessageSentAt.compareTo(a.lastMessageSentAt)
        );
        
        state = AsyncData(updatedChats);
      });
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  Future<void> getRooms() async {
    state = const AsyncLoading();
    try {
      final chatList = await _getChatListUseCase.execute();
      
      final ws = ref.read(wsClientProvider);
      if (chatList != null) {
        for (final room in chatList) {
          ws.subscribeToRoom(room.id);
        }
      }
      
      state = AsyncData(chatList);
    } catch (e, trace) {
      state = AsyncError(e, trace);
    }
  }
  
  void markAsRead(String roomId) {
    state.whenData((rooms) {
      if (rooms == null) return;
      
      final updatedChats = rooms.map((room) {
        if (room.id == roomId) {
          return room.copyWith(unreadMessagesCount: 0);
        }
        return room;
      }).toList();
      
      state = AsyncData(updatedChats);
    });
  }
}
