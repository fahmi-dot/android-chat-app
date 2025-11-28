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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    final phoneNumber = _phoneNumberController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final cPassword = _cPasswordController.text.trim();
    final success = await ref
        .read(authProvider.notifier)
        .register(phoneNumber, email, password, cPassword);

    if (mounted && success) {
      context.go(
        Routes.verifyWithPhone(phoneNumber),
        extra: {'email': email, 'password': password},
      );
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
      body: SafeArea(
        child: Column(
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
                        CustomBanner(icon: HeroIcons.identification),
                        const SizedBox(height: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.registerTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingL),
                            Text(
                              AppStrings.registerSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        CustomTextField(
                          controller: _phoneNumberController,
                          text: AppStrings.phoneNumber,
                          showLabel:  true,
                          type: CustomTextFieldType.phone,
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextField(
                          controller: _emailController,
                          text: AppStrings.email,
                          showLabel:  true,
                          type: CustomTextFieldType.email,
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextField(
                          controller: _passwordController,
                          text: AppStrings.password,
                          showLabel:  true,
                          type: CustomTextFieldType.password,
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextField(
                          controller: _cPasswordController,
                          text: AppStrings.cPassword,
                          showLabel:  true,
                          type: CustomTextFieldType.password,
                        ),
                        const SizedBox(height: 32.0),
                        authState.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => CustomButton(
                            text: AppStrings.register.toUpperCase(),
                            onPressed: _register,
                          ),
                          data: (user) => CustomButton(
                            text: AppStrings.register.toUpperCase(),
                            onPressed: _register,
                          ),
                        ),
                      ],
                    ),
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
                    AppStrings.alreadyHaveAccount,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  CustomTextButton(
                    text: AppStrings.login,
                    onPressed: () => context.pop(),
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
