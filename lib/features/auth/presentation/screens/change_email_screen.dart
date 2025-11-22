import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_button.dart';
import 'package:android_chat_app/shared/widgets/custom_text_button.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String email;
  final String password;

  const ChangeEmailScreen({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeEmail() async {
    final email = _controller.text.trim();

    final success = await ref
        .read(authProvider.notifier)
        .register(
          widget.phoneNumber,
          email,
          widget.password,
          widget.password,
        );

    if (!mounted) return;

    if (success) {
      context.pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

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
                        CustomBanner(icon: HeroIcons.pencilSquare),
                        const SizedBox(height: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.changeEmailTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingL),
                            Text(
                              AppStrings.changeEmailSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        CustomTextField(
                          controller: _controller,
                          text: AppStrings.email,
                          showLabel: true,
                          type: CustomTextFieldType.email,
                        ),
                        const SizedBox(height: 32.0),
                        authState.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => CustomButton(
                            text: AppStrings.save.toUpperCase(),
                            onPressed: _changeEmail,
                          ),
                          data: (user) => CustomButton(
                            text: AppStrings.save.toUpperCase(),
                            onPressed: _changeEmail,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextButton(
                          text: AppStrings.cancel,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
