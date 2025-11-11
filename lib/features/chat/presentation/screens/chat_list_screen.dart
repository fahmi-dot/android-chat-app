import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(authProvider.notifier).logout();

      if (mounted) context.go('/');
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _keyword = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatListState = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: AppColors.surface),
                ),
                style: const TextStyle(
                  color: AppColors.surface,
                  fontSize: AppSizes.fontL,
                ),
                onChanged: (value) {
                  setState(() {
                    _keyword = value.toLowerCase();
                  });
                },
              )
            : const Text(
                'Hello!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _toggleSearch),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else if (value == 'settings') {
                context.push('/settings');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: chatListState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading chats: $e')),
        data: (rooms) {
          if (rooms == null || rooms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat,
                    size: AppSizes.iconXXL,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    'No chats yet',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Start a new conversation',
                    style: TextStyle(
                      fontSize: AppSizes.fontM,
                      color: Colors.grey[600],
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
                  Icon(
                    Icons.search_off,
                    size: AppSizes.iconXXL,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppSizes.paddingM),
                  Text(
                    'No chats found',
                    style: TextStyle(
                      fontSize: AppSizes.fontL,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: filteredRooms.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[200]),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingM,
                    vertical: AppSizes.paddingS,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(room.avatarUrl),
                            backgroundColor: Colors.grey[400],
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
                                    color: AppColors.surface,
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
                                    style: TextStyle(
                                      fontSize: AppSizes.fontL,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.paddingS),
                                Text(
                                  room.lastMessageSentAt.toString(),
                                  style: TextStyle(
                                    fontSize: AppSizes.fontS,
                                    color: Colors.grey[600],
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
                                    style: TextStyle(
                                      color: hasUnread
                                          ? Colors.black
                                          : Colors.grey[600],
                                      fontSize: AppSizes.fontM,
                                      fontWeight: hasUnread
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.paddingS),
                                if (hasUnread)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                                    ),
                                    child: Text(
                                      room.unreadMessagesCount > 99
                                          ? '99+'
                                          : room.unreadMessagesCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.fontS,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
        child: const Icon(Icons.chat),
        onPressed: () {},
      ),
    );
  }
}
