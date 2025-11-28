import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchUserScreen extends ConsumerStatefulWidget {
  const SearchUserScreen({super.key});

  @override
  ConsumerState<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends ConsumerState<SearchUserScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchUserState = ref.watch(userSearchProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: AppStrings.search,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
              fontSize: AppSizes.font2XL,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onChanged: (value) {
            setState(() {
              ref.read(userSearchProvider.notifier).searchUser(
                value.toLowerCase().trim(),
              );
            });
          },
        )
      ),
      body: searchUserState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Error loading search user: $e',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        data: (users) {
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Theme.of(context).colorScheme.surface),
            itemBuilder: (context, index) {
              final user = users[index];

              return InkWell(
                onTap: () => context.push(Routes.chatWithRoom(user.username), extra: user.username),
                onLongPress: () {},
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(user.avatarUrl),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    user.displayName,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
        }
      ),
    );
  }
}
