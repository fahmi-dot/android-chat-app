import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/theme/theme_provider.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
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
    return Drawer(
      child: Column(
        children: [
          Container(
            width: AppSizes.screenWidth(context),
            height: AppSizes.screenHeight(context) * 0.2,
            padding: EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 65.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: AppSizes.paddingXS),
                        Text(
                          'Display Name',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        Text(
                          'Phone Number',
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
                      IconButton(
                        onPressed: () =>
                            ref.read(themeProvider.notifier).toggle(),
                        icon: HeroIcon(
                          HeroIcons.moon,
                          style: HeroIconStyle.solid,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSizes.paddingM),
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: HeroIcon(
                    HeroIcons.userCircle,
                    style: HeroIconStyle.outline,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'My Profile',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: HeroIcon(
                    HeroIcons.cog6Tooth,
                    style: HeroIconStyle.outline,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: HeroIcon(
                    HeroIcons.arrowLeftStartOnRectangle,
                    style: HeroIconStyle.outline,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: Text(
                    AppStrings.logout,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: AppSizes.paddingXL),
            child: Image.asset(
              'assets/icons/icon_hello.png',
              width: AppSizes.screenWidth(context) * 0.15,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
