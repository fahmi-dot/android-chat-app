import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_button.dart';
import 'package:android_chat_app/shared/widgets/custom_notification.dart';
import 'package:android_chat_app/shared/widgets/custom_text_button.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final success = await ref
        .read(authProvider.notifier)
        .login(username, password);

    if (mounted && success) {
      context.go(Routes.chatList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) {
          final message = e.toString().replaceFirst("Exception: ", "");

          showCustomNotification(
            context,
            HeroIcons.exclamationTriangle,
            message,
            CustomNotificationType.error
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(AppSizes.paddingXS),
              child: Center(
                child: Image.asset(
                  Theme.of(context).brightness != Brightness.dark 
                      ? 'assets/icons/icon_hello_light.png'
                      : 'assets/icons/icon_hello_dark.png', 
                  width: AppSizes.screenWidth(context) * 0.2,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomBanner(icon: HeroIcons.user),
                            const SizedBox(height: 32.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppStrings.loginTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Theme.of(context,).colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.paddingL),
                                Text(
                                  AppStrings.loginSubtitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color:Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32.0),
                            CustomTextField(
                              controller: _usernameController,
                              text: AppStrings.username,
                              showLabel: true,
                              type: CustomTextFieldType.text,
                            ),
                            const SizedBox(height: AppSizes.paddingM),
                            CustomTextField(
                              controller: _passwordController,
                              text: AppStrings.password,
                              showLabel: true,
                              type: CustomTextFieldType.password,
                            ),
                            const SizedBox(height: 32.0),
                            authState.when(
                              loading: () => const CircularProgressIndicator(),
                              error: (e, _) => CustomButton(
                                text: AppStrings.login.toUpperCase(),
                                onPressed: _login,
                              ),
                              data: (user) => CustomButton(
                                text: AppStrings.login.toUpperCase(),
                                onPressed: _login,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingM),
                            TextButton(
                              onPressed: () => context.push(Routes.forgot),
                              child: Text(
                                AppStrings.forgotPassword,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
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
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingXS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.dontHaveAccount,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  CustomTextButton(
                    text: AppStrings.register,
                    onPressed: () => context.push(Routes.register),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
