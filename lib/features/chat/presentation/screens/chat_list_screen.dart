import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/chat/presentation/providers/chat_list_provider.dart';
import 'package:android_chat_app/features/chat/presentation/widgets/drawer_widget.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final TextEditingController _controller = TextEditingController();
  String _keyword = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _controller.clear();
        _keyword = '';
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final chatListState = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: HeroIcon(
              HeroIcons.bars3, 
              style: HeroIconStyle.outline,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: _isSearching
            ? CustomTextField(
                controller: _controller,
                text: AppStrings.search,
                showHint: true,
                onChange: (value) {
                  setState(() {
                    _keyword = value.toLowerCase();
                  });
                },
                type: CustomTextFieldType.text,
              )
            : Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
        actions: [
          IconButton(
            icon: HeroIcon(
              HeroIcons.magnifyingGlass,
              style: HeroIconStyle.outline,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: _toggleSearch,
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
                    AppStrings.noChats,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    AppStrings.noChatsSub,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            );
          }

          final filteredRooms = _keyword.isEmpty
              ? rooms
              : rooms.where((room) {
                  return room.displayName.toLowerCase().contains(_keyword) ||
                      room.lastMessage.toLowerCase().contains(_keyword);
                }).toList();

          if (filteredRooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeroIcon(
                    HeroIcons.chatBubbleLeftRight,
                    style: HeroIconStyle.solid,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                    size: 80.0,
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    AppStrings.noChatsFound,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: filteredRooms.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Theme.of(context).colorScheme.surface),
            itemBuilder: (context, index) {
              final room = filteredRooms[index];
              final hasUnread = room.unreadMessagesCount > 0;

              return InkWell(
                onTap: () {
                  context.push('/chats/${room.id}').then((_) {
                    ref.invalidate(chatListProvider);
                  });
                },
                onLongPress: () {},
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(room.avatarUrl),
                            backgroundColor: Theme.of(context).colorScheme.surface,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    room.displayName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.paddingXL),
                                Text(
                                  formatTime(room.lastMessageSentAt),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                      color: hasUnread
                                          ? Theme.of(context).colorScheme.onSurface
                                          : Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w400,
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
        onPressed: () {},
      ),
    );
  }
}
