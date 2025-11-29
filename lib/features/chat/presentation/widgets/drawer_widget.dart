import 'dart:math';

import 'package:android_chat_app/shared/widgets/custom_on_working_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/shared/providers/theme_provider.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/features/user/presentation/providers/user_provider.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userProvider.notifier).getMyProfile();
    });
  }

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppStrings.logout.toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          AppStrings.logoutTitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppStrings.cancel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppStrings.logout,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await ref.read(authProvider.notifier).logout();

      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider).value;
    if (userState == null) return CircularProgressIndicator();

    return Drawer(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Stack(
              children: [
                Container(
                  width: AppSizes.screenWidth(context),
                  height: AppSizes.screenHeight(context) * 0.2,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Positioned(
                  top: -100.0,
                  left: -50.0,
                  child: SizedBox(
                    child: Transform.rotate(
                      angle: -30 * pi / 180,
                      child: Image.asset(
                        'assets/icons/icon_hello.png',
                        width: AppSizes.screenWidth(context),
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: AppSizes.screenWidth(context) * 0.75,
                  height: AppSizes.screenHeight(context) * 0.2,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSizes.paddingM,
                    horizontal: AppSizes.paddingXXL,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => context.push(Routes.myProfile),
                                child: Container(
                                  height: 65.0,
                                  width: 65.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surface,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(userState.avatarUrl),
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSizes.paddingXS),
                              Text(
                                userState.displayName,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: AppSizes.fontL,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userState.phoneNumber,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: AppSizes.paddingM),
                              child: GestureDetector(
                                onTap: () => ref.read(themeProvider.notifier).toggle(),
                                child: HeroIcon(
                                  Theme.of(context).colorScheme.brightness == Brightness.dark
                                      ? HeroIcons.moon
                                      : HeroIcons.sun,
                                  style: HeroIconStyle.solid,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: AppSizes.screenHeight(context) * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenu(HeroIcons.userCircle, AppStrings.myProfile, () => context.push(Routes.myProfile)),
                      _buildMenu(HeroIcons.cog6Tooth, AppStrings.setting, () => showCustomOnWorkingNotification(context)),
                      _buildMenu(HeroIcons.arrowLeftStartOnRectangle, AppStrings.logout, () => _logout()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  child: Image.asset(
                    'assets/icons/icon_hello.png',
                    width: AppSizes.screenWidth(context) * 0.15,
                    color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu(HeroIcons icon, String label, Function() onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.paddingXXL),
      leading: HeroIcon(
        icon,
        style: HeroIconStyle.outline,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
