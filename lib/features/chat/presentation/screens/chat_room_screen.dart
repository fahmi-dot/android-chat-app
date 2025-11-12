import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String roomId;

  const ChatRoomScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatListProvider.notifier).markAsRead(widget.roomId);
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
        .sendMessage(message);

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
    final roomDetail = ref
        .watch(chatListProvider)
        .value
        ?.firstWhere((room) => room.id == widget.roomId);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: AppSizes.radiusL + 2.0,
              backgroundImage: roomDetail?.avatarUrl != null
                  ? NetworkImage(roomDetail!.avatarUrl)
                  : null,
              backgroundColor: AppColors.background,
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomDetail?.displayName ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.fontL,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.paddingXS),
                  const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.fontS,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              error: (e, _) =>
                  Center(child: Text('Error loading messages: $e')),
              data: (messages) {
                if (messages == null || messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroIcon(
                          HeroIcons.chatBubbleLeftEllipsis,
                          style: HeroIconStyle.solid,
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                          size: 80.0,
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Text(
                          AppStrings.noMessages,
                          style: TextStyle(
                            color: AppColors.textPrimary.withValues(alpha: 0.4),
                            fontSize: AppSizes.fontL,
                            fontWeight: FontWeight.bold,
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
                                ? AppColors.primary
                                : AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                sameAsPrev && !isMe && isLast
                                    ? 4
                                    : AppSizes.radiusL,
                              ),
                              topRight: Radius.circular(
                                sameAsPrev && isMe && isLast
                                    ? 4
                                    : AppSizes.radiusL,
                              ),
                              bottomLeft: Radius.circular(
                                isMe ? AppSizes.radiusL : 4,
                              ),
                              bottomRight: Radius.circular(
                                isMe ? 4 : AppSizes.radiusL,
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
                                    color: isMe ? Colors.white : Colors.black,
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
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: AppSizes.paddingXS),
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
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.01),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingM,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusXL + 4,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: AppStrings.message,
                          hintStyle: TextStyle(color: AppColors.textSecondary),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontL,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.paddingM),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const HeroIcon(
                        HeroIcons.paperAirplane,
                        style: HeroIconStyle.solid,
                      ),
                      onPressed: _sendMessage,
                      color: Colors.white,
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
