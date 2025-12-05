import 'package:android_chat_app/shared/providers/client_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_on_working_notification.dart';
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
  final String username;

  const ChatRoomScreen({super.key, required this.username});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _onSelecting = false;
  String _selectedMessage = '';
  String? roomId;

  @override
  void initState() {
    super.initState();

    final ws = ref.read(wsClientProvider);
    ws.onMessage = _onWsMessage;

    Future.microtask(() async {
      ref.read(userDetailProvider.notifier).getUserProfile(widget.username);
      final rooms = await ref
          .read(chatListProvider.notifier)
          .searchChatRooms(widget.username);

      if (rooms.isNotEmpty) {
        setState(() {
          roomId = rooms.first.id;
        });

        await ref.read(chatListProvider.notifier).markAsRead(roomId!);
      }

    });

    _controller.addListener(() {
      final hasText = _controller.text.isNotEmpty;

      if (_isTyping != hasText) {
        setState(() {
          _isTyping = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onWsMessage(Map<String, dynamic> data) {
    if (data['type'] == 'new_room') {
      final rId = data['roomId'];

      if (roomId == null) {
        setState(() {
          roomId = rId;
        });

        ref.invalidate(chatRoomProvider(roomId));
      }
    }
  }

  void _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    await ref
        .read(chatRoomProvider(roomId).notifier)
        .sendMessage(message, widget.username);

    _controller.clear();
  }

  void _showPopup(LongPressStartDetails details, RenderBox overlay) {
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        (details.globalPosition + Offset(0, AppSizes.paddingL)) 
            & Size(40.0, 40.0),
        Offset.zero & overlay.size,
      ),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      items: [
        _popupItem(HeroIcons.queueList, 'Select', () => showCustomOnWorkingNotification(context)),
        _popupItem(HeroIcons.pencil, 'Edit', () => showCustomOnWorkingNotification(context)),
        _popupItem(HeroIcons.trash, 'Delete', () => showCustomOnWorkingNotification(context)),
      ],
    ).then((value) {
      setState(() {
        _onSelecting = false;
        _selectedMessage = '';
      });
    });
  }


  PopupMenuItem<dynamic> _popupItem(HeroIcons icon, String label, Function()? onTap) {
    return PopupMenuItem(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            HeroIcon(
              icon,
              style: HeroIconStyle.solid,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20.0,
            ),
            SizedBox(width: AppSizes.paddingM),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomState = ref.watch(chatRoomProvider(roomId));
    final userDetailState = ref.watch(userDetailProvider).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () => showCustomOnWorkingNotification(context),
          child: Row(
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: Row(
              spacing: AppSizes.paddingM,
              children: [
                GestureDetector(
                  onTap: () => showCustomOnWorkingNotification(context),
                  child: HeroIcon(
                    HeroIcons.phone,
                    style: HeroIconStyle.solid,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => showCustomOnWorkingNotification(context),
                  child: HeroIcon(
                    HeroIcons.ellipsisVertical,
                    style: HeroIconStyle.solid,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: AppSizes.iconL,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatRoomState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Error loading messages: $e',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                            size: 80.0,
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          Text(
                            AppStrings.noMessagesTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.3),
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
                      bool isSelected = _selectedMessage == message.id;
                                        
                      if (isNotLast) {
                        sameAsPrev = isMe == messages[index + 1].isSentByMe
                            ? true
                            : false;
                      }
                                        
                      return Opacity(
                        opacity: _onSelecting
                            ? isSelected ? 1.0 : 0.3
                            : 1.0,
                        child: GestureDetector(
                          onLongPressStart: (details) {
                            setState(() {
                              _onSelecting = true;
                              _selectedMessage = message.id;
                            });
                            final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                            _showPopup(details, overlay);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppSizes.paddingS),
                            child: Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: AppSizes.screenWidth(context) * 0.75,
                                ),
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
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
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
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary
                                                      .withValues(alpha: 0.7)
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        if (isMe) ...[
                                          const SizedBox(
                                            width: AppSizes.paddingS,
                                          ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: AppSizes.paddingM,
                    children: [
                      SizedBox(
                        height: AppSizes.screenHeight(context) * 0.06,
                        child: GestureDetector(
                          onTap: () => showCustomOnWorkingNotification(context),
                          child: HeroIcon(
                            HeroIcons.faceSmile,
                            style: HeroIconStyle.outline,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: AppSizes.iconL,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: _controller,
                          text: AppStrings.message,
                          maxLines: 5,
                          showHint: true,
                          onSubmitted: (value) => _sendMessage(),
                          type: CustomTextFieldType.text,
                        ),
                      ),
                      _isTyping
                          ? Container(
                              height: AppSizes.screenHeight(context) * 0.06,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: HeroIcon(
                                  HeroIcons.paperAirplane,
                                  style: HeroIconStyle.solid,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                onPressed: _sendMessage,
                              ),
                            )
                          : SizedBox(
                              height: AppSizes.screenHeight(context) * 0.06,
                              child: Row(
                                spacing: AppSizes.paddingM,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        showCustomOnWorkingNotification(
                                          context,
                                        ),
                                    child: HeroIcon(
                                      HeroIcons.paperClip,
                                      style: HeroIconStyle.outline,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      size: AppSizes.iconL,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        showCustomOnWorkingNotification(
                                          context,
                                        ),
                                    child: HeroIcon(
                                      HeroIcons.camera,
                                      style: HeroIconStyle.outline,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      size: AppSizes.iconL,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
