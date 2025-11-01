import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('This is chat list screen'),
            authState.when(
              data: (user) => (user != null)
                ? Text(user.isLoggedIn.toString())
                : Text('User not logged in'),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const Text('Error')
            ),
          ],
        )
      ),
    );
  }
}