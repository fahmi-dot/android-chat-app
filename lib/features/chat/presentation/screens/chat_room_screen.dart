import 'package:android_chat_app/features/chat/presentation/providers/chat_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;
  const ChatRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final chatRoomState = ref.watch(chatRoomProvider(widget.roomId));

    return Scaffold(
      appBar: AppBar(title: const Text('Message')),
      body: chatRoomState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading messages: $e')),
        data: (message) {
          if (message == null || message.isEmpty) {
            return const Center(child: Text('No message found'));
          }

          return ListView.builder(
            itemCount: message.length,
            itemBuilder: (context, index) {
              final m = message[index];
              return ListTile(title: Text(m.content), subtitle: Text(m.sentAt.toString()));
            },
          );
        },
      ),
    );
  }
}
