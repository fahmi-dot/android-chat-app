import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_button.dart';
import 'package:android_chat_app/shared/widgets/custom_notification.dart';
import 'package:android_chat_app/shared/widgets/custom_text_button.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String email;
  final String password;

  const VerifyScreen({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<VerifyScreen> createState() => _CodeVerifyScreenState();
}

class _CodeVerifyScreenState extends ConsumerState<VerifyScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  String? newEmail;

  @override
  void dispose() {
    super.dispose();
  }

  void _verify() async {
    final success = await ref
        .read(authProvider.notifier)
        .verify(
          widget.phoneNumber,
          _controllers.map((c) => c.text).join(),
          widget.password,
        );

    if (!mounted) return;

    if (success) {
      context.go(Routes.setUsername);
    }
  }

  void _resendCode() async {
    final success = await ref
        .read(authProvider.notifier)
        .resendCode(widget.phoneNumber);

    if (!mounted) return;

    final message = success
        ? 'Verification code sent'
        : 'Failed to send verification code. Please try again';

    showCustomNotification(
      context,
      success ? HeroIcons.envelope : HeroIcons.exclamationTriangle,
      message,
    );
  }

  void _changeEmail() async {
    newEmail = await context.push<String>(
      Routes.changeEmail,
      extra: {
        'phoneNumber': widget.phoneNumber,
        'email': widget.email,
        'password': widget.password,
      },
    );
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
                        CustomBanner(icon: HeroIcons.shieldExclamation),
                        const SizedBox(height: 32.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.verifyTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSizes.paddingL),
                            Text(
                              newEmail == null
                                  ? AppStrings.verifySubtitle + widget.email
                                  : AppStrings.verifySubtitle + newEmail!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context,).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => CustomTextField(
                              width: AppSizes.screenHeight(context) * 0.06,
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              onChange: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 3) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else {
                                    _focusNodes[index].unfocus();
                                  }
                                } else {
                                  if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                }
                              },
                              type: CustomTextFieldType.otp,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.didntReceive,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            CustomTextButton(
                              text: AppStrings.resend,
                              onPressed: _resendCode,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        authState.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => CustomButton(
                            text: AppStrings.verify.toUpperCase(),
                            onPressed: _verify,
                          ),
                          data: (user) => CustomButton(
                            text: AppStrings.verify.toUpperCase(),
                            onPressed: _verify,
                          ),
                        ),
                        const SizedBox(height: AppSizes.paddingM),
                        CustomTextButton(
                          text: AppStrings.changeEmail,
                          onPressed: _changeEmail,
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
