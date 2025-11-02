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
        data: (chatList) {
          if (chatList == null || chatList.isEmpty) {
            return const Center(child: Text('No chats found'));
          }

          return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index) {
              final chat = chatList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat.avatarUrl),
                ),
                title: Text(chat.displayName),
                subtitle: Text(chat.username),
                onTap: () {
                  context.go('/chats/$chat.id');
                },
              );
            },
          );
        },
      ),
    );
  }
}
