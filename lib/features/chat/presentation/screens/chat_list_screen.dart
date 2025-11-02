import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final chatListState = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: chatListState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading chats: $e')),
        data: (room) {
          if (room == null || room.isEmpty) {
            return const Center(child: Text('No chats found'));
          }

          return ListView.builder(
            itemCount: room.length,
            itemBuilder: (context, index) {
              final r = room[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(r.avatarUrl),
                ),
                title: Text(r.displayName),
                subtitle: Text(r.username),
                onTap: () {
                  context.push('/chats/${r.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
