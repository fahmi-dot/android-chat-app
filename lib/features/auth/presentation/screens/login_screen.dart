import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
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

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: AppSizes.screenWidth(context),
                            height: AppSizes.screenHeight(context) * 0.2,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                              padding: EdgeInsets.all(32.0),
                              child: HeroIcon(
                                HeroIcons.user,
                                color: AppColors.primary,
                                size: 80.0,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 35,
                            bottom: 10,
                            child: Container(
                              width: AppSizes.iconL * 2,
                              height: AppSizes.iconL * 2,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 75,
                            top: 0,
                            child: Container(
                              width: AppSizes.iconXS,
                              height: AppSizes.iconXS,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 50,
                            bottom: 50,
                            child: Container(
                              width: AppSizes.iconXL,
                              height: AppSizes.iconXL,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32.0),
                      Text(
                        AppStrings.loginTitle,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontXXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Container(
                        height: AppSizes.screenHeight(context) * 0.07,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXXL,
                          ),
                        ),
                        child: TextField(
                          controller: _usernameController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: AppStrings.username,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppSizes.fontL,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Container(
                        height: AppSizes.screenHeight(context) * 0.07,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.paddingM,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusXXL,
                          ),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: AppStrings.password,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: AppSizes.fontL,
                          ),
                          maxLines: 1,
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      authState.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Column(
                          children: [
                            SizedBox(
                              width: AppSizes.screenWidth(context),
                              height: AppSizes.screenHeight(context) * 0.07,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                child: Text(
                                  AppStrings.login.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: AppSizes.fontL,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Error: $e',
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                        data: (user) => SizedBox(
                          width: AppSizes.screenWidth(context),
                          height: AppSizes.screenHeight(context) * 0.07,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              AppStrings.login.toUpperCase(),
                              style: TextStyle(
                                fontSize: AppSizes.fontL,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.forgot,
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(AppStrings.noAccount),
                SizedBox(width: AppSizes.paddingXS),
                Text(
                  AppStrings.register,
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
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
