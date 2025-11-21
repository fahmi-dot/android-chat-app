import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/theme/theme_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_button.dart';
import 'package:android_chat_app/shared/widgets/custom_notification.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

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

    if (!mounted) return;

    if (success) {
      context.go('/chats');
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
          );
        },
      );
    });

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SizedBox(
                        width: AppSizes.screenWidth(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () =>
                                    ref.read(themeProvider.notifier).toggle(),
                                icon: HeroIcon(
                                  Theme.of(context).brightness !=
                                          Brightness.dark
                                      ? HeroIcons.moon
                                      : HeroIcons.sun,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  style: HeroIconStyle.solid,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomBanner(icon: HeroIcons.user),
                          const SizedBox(height: 32.0),
                          Text(
                            AppStrings.loginTitle,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppSizes.fontXXL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          CustomTextField(
                            height: AppSizes.screenHeight(context) * 0.07,
                            radius: AppSizes.radiusXXL,
                            controller: _usernameController,
                            hintText: AppStrings.username,
                            fontSize: AppSizes.fontL,
                            maxLines: 1,
                            type: CustomTextFieldType.text,
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          CustomTextField(
                            height: AppSizes.screenHeight(context) * 0.07,
                            radius: AppSizes.radiusXXL,
                            controller: _passwordController,
                            hintText: AppStrings.password,
                            fontSize: AppSizes.fontL,
                            maxLines: 1,
                            type: CustomTextFieldType.password,
                          ),
                          const SizedBox(height: 32.0),
                          authState.when(
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Column(
                              children: [
                                CustomButton(
                                  height: AppSizes.screenHeight(context) * 0.07,
                                  text: AppStrings.login.toUpperCase(),
                                  onPressed: _login,
                                ),
                              ],
                            ),
                            data: (user) => CustomButton(
                              height: AppSizes.screenHeight(context) * 0.07,
                              text: AppStrings.login.toUpperCase(),
                              onPressed: _login,
                            ),
                          ),
                          const SizedBox(height: AppSizes.paddingM),
                          TextButton(
                            onPressed: () => context.push('/forgot'),
                            child: Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(
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
            padding: const EdgeInsets.all(AppSizes.fontS),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.dontHaveAccount,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text(
                    AppStrings.register,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
