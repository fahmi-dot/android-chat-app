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

class SetUsernameScreen extends ConsumerStatefulWidget {
  const SetUsernameScreen({super.key});

  @override
  ConsumerState<SetUsernameScreen> createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends ConsumerState<SetUsernameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setUsername() async {
    final username = _controller.text.trim();

    final success = await ref
        .read(authProvider.notifier)
        .setProfile(username, null, null);

    if (!mounted) return;

    if (success) {
      context.go('/chats');
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
                        CustomBanner(icon: HeroIcons.identification),
                        const SizedBox(height: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.setUsernameTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingL),
                            Text(
                              AppStrings.setUsernameSubtitle,
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
                          hintText: AppStrings.username,
                          maxLines: 1,
                          type: CustomTextFieldType.text,
                        ),
                        const SizedBox(height: 32.0),
                        authState.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => CustomButton(
                            text: AppStrings.save.toUpperCase(),
                            onPressed: _setUsername,
                          ),
                          data: (user) => CustomButton(
                            text: AppStrings.save.toUpperCase(),
                            onPressed: _setUsername,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextButton(
                          text: AppStrings.skip,
                          onPressed: () => context.go('/chats'),
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
