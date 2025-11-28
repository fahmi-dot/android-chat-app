import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_room_provider.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_detail_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String? roomId;
  final String? username;

  const ChatRoomScreen({super.key, this.roomId, this.username});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userDetailProvider.notifier).getUserProfile(widget.username!);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatListProvider.notifier).markAsRead(widget.roomId!);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    await ref
        .read(chatRoomProvider(widget.roomId).notifier)
        .sendMessage(message, widget.username);

    _controller.clear();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomState = ref.watch(chatRoomProvider(widget.roomId));
    final userDetailState = ref.watch(userDetailProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: AppSizes.radiusL + 2.0,
              backgroundImage: userDetailState?.avatarUrl != null 
                  ? NetworkImage(userDetailState!.avatarUrl)
                  : null,
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userDetailState?.displayName ?? 'User',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  Text(
                    'Online',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view_contact',
                child: Text('View Contact'),
              ),
              const PopupMenuItem(
                value: 'media',
                child: Text('Media, Links, and Docs'),
              ),
              const PopupMenuItem(
                value: 'mute',
                child: Text('Mute Notifications'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatRoomState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error loading messages: $e',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              ),
              data: (messages) {
                if (messages == null || messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroIcon(
                          HeroIcons.chatBubbleLeftEllipsis,
                          style: HeroIconStyle.solid,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                          size: 80.0,
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Text(
                          AppStrings.noMessagesTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.isSentByMe;
                    final isNotLast = index < messages.length - 1;
                    final isLast = index != messages.length - 1;
                    bool sameAsPrev = true;

                    if (isNotLast) {
                      sameAsPrev = isMe == messages[index + 1].isSentByMe
                          ? true
                          : false;
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.paddingXS),
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingM,
                            vertical: AppSizes.paddingS,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                sameAsPrev && !isMe && isLast
                                    ? 4
                                    : AppSizes.radiusM,
                              ),
                              topRight: Radius.circular(
                                sameAsPrev && isMe && isLast
                                    ? 4
                                    : AppSizes.radiusM,
                              ),
                              bottomLeft: Radius.circular(
                                isMe ? AppSizes.radiusM : 4,
                              ),
                              bottomRight: Radius.circular(
                                isMe ? 4 : AppSizes.radiusM,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isMe 
                                        ? Theme.of(context).colorScheme.onPrimary 
                                        : Theme.of(context).colorScheme.onSurface,
                                    fontSize: AppSizes.fontM,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.paddingS),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _formatTime(message.sentAt),
                                    style: TextStyle(
                                      fontSize: AppSizes.fontS,
                                      color: isMe
                                          ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7)
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: AppSizes.paddingS),
                                    Icon(
                                      Icons.done_all,
                                      size: AppSizes.iconS,
                                      color: message.isRead
                                          ? Colors.blue[200]
                                          : Colors.grey[400],
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: AppSizes.paddingM,
                      ),
                      child: CustomTextField(
                        controller: _controller, 
                        text: AppStrings.message,
                        maxLines: 5,
                        showHint: true,
                        onSubmitted: (value) => _sendMessage(),
                        type: CustomTextFieldType.text
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.paddingM),
                  Container(
                    margin: const EdgeInsets.only(
                      right: AppSizes.paddingM,
                    ),
                    height: AppSizes.screenHeight(context) * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: HeroIcon(
                        HeroIcons.paperAirplane,
                        style: HeroIconStyle.solid,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
