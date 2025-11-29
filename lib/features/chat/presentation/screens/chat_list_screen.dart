import 'package:android_chat_app/shared/widgets/custom_on_working_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/chat/presentation/widgets/drawer_widget.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  bool _onSelecting = false;
  String _selectedRoom = '';

  @override
  void dispose() {
    super.dispose();
  }

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat.Hm().format(dateTime);
    } else if (messageDate == yesterday) {
      return 'Kemarin';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
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
        _popupItem(HeroIcons.archiveBoxArrowDown, 'Archive', () => showCustomOnWorkingNotification(context)),
        _popupItem(HeroIcons.trash, 'Delete', () => showCustomOnWorkingNotification(context)),
      ],
    ).then((value) {
      setState(() {
        _onSelecting = false;
        _selectedRoom = '';
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

  @override
  Widget build(BuildContext context) {
    final chatListState = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: HeroIcon(
              HeroIcons.bars3, 
              style: HeroIconStyle.outline,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingM),
            child: GestureDetector(
              onTap: () => context.push(Routes.searchUser),
              child: HeroIcon(
                HeroIcons.magnifyingGlass,
                style: HeroIconStyle.outline,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: chatListState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error loading chats: $e',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        data: (rooms) {
          if (rooms == null || rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeroIcon(
                    HeroIcons.chatBubbleBottomCenterText,
                    style: HeroIconStyle.solid,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 80.0,
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    AppStrings.noChatsTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    AppStrings.noChatsSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: rooms.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Theme.of(context).colorScheme.surface),
            itemBuilder: (context, index) {
              final room = rooms[index];
              final hasUnread = room.unreadMessagesCount > 0;
              bool isSelected = _selectedRoom == room.id;

              return Opacity(
                opacity: _onSelecting
                    ? isSelected ? 1.0 : 0.3
                    : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: _onSelecting
                        ? isSelected 
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.surfaceContainer
                        : Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: AppSizes.radiusXXL,
                            backgroundImage: NetworkImage(room.avatarUrl),
                          ),
                          if (true)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: AppSizes.paddingM,
                                height: AppSizes.paddingM,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: AppSizes.paddingM),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.push(Routes.chatWithRoom(room.id), extra: room.username).then((_) {
                              ref.invalidate(chatListProvider);
                            });
                          },
                          onLongPressStart: (details) {
                            setState(() {
                              _onSelecting = true;
                              _selectedRoom = room.id;
                            });
                            final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                            _showPopup(details, overlay);
                          },  
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      room.displayName,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.paddingXL),
                                  Text(
                                    formatTime(room.lastMessageSentAt),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: hasUnread
                                          ? Theme.of(context).colorScheme.secondary
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.paddingXS),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      room.lastMessage,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (hasUnread) ...[
                                    const SizedBox(width: AppSizes.paddingXL),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        room.unreadMessagesCount > 99
                                            ? '99+'
                                            : room.unreadMessagesCount.toString(),
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        )
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: HeroIcon(
          HeroIcons.chatBubbleBottomCenterText,
          style: HeroIconStyle.solid,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () => showCustomOnWorkingNotification(context),
      ),
    );
  }
}
