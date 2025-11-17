import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_button.dart';
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
    final success = await ref
        .read(authProvider.notifier)
        .register(
          widget.phoneNumber,
          _controller.text,
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
                      CustomBanner(icon: HeroIcons.pencilSquare),
                      const SizedBox(height: 32.0),
                      Text(
                        AppStrings.changeEmailTitle,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontXXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      CustomTextField(
                        height: AppSizes.screenHeight(context) * 0.07,
                        radius: AppSizes.radiusXXL,
                        controller: _controller,
                        hintText: AppStrings.email,
                        fontSize: AppSizes.fontL,
                        maxLines: 1,
                        type: CustomTextFieldType.email,
                        theme: CustomTextFieldTheme.light,
                      ),
                      const SizedBox(height: 32.0),
                      authState.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Column(
                          children: [
                            CustomButton(
                              height: AppSizes.screenHeight(context) * 0.07,
                              text: AppStrings.save.toUpperCase(),
                              onPressed: _changeEmail,
                              theme: CustomButtonTheme.light,
                            ),
                          ],
                        ),
                        data: (user) => CustomButton(
                          height: AppSizes.screenHeight(context) * 0.07,
                          text: AppStrings.save.toUpperCase(),
                          onPressed: _changeEmail,
                          theme: CustomButtonTheme.light,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          AppStrings.cancel,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
