import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:android_chat_app/core/constants/app_strings.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:android_chat_app/shared/widgets/custom_banner.dart';
import 'package:android_chat_app/shared/widgets/custom_button.dart';
import 'package:android_chat_app/shared/widgets/custom_text_field.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String email;

  const VerifyScreen({
    super.key,
    required this.phoneNumber,
    required this.email,
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

  @override
  void dispose() {
    super.dispose();
  }

  void _verify() async {
    final success = await ref
        .read(authProvider.notifier)
        .verify(widget.phoneNumber, _controllers.map((c) => c.text).join());

    if (!mounted) return;

    if (success) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (e, _) {
          final message = e.toString().replaceFirst("Exception: ", "");

          Flushbar(
            icon: Icon(Icons.error_outline, color: Colors.white),
            message: message,
            margin: EdgeInsets.symmetric(
              vertical: AppSizes.paddingM,
              horizontal: 32.0,
            ),
            backgroundColor: AppColors.error,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            flushbarPosition: FlushbarPosition.TOP,
            duration: Duration(seconds: 2),
          ).show(context);
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
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomBanner(icon: HeroIcons.key),
                      const SizedBox(height: 32.0),
                      Text(
                        AppStrings.verifyTitle,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontXXL,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      Text(
                        AppStrings.verifySubtitle + widget.email,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontL,
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingXL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => CustomTextField(
                            width: AppSizes.screenHeight(context) * 0.07,
                            height: AppSizes.screenHeight(context) * 0.07,
                            radius: AppSizes.radiusL,
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            fontSize: AppSizes.fontXXL,
                            maxLines: 1,
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
                            theme: CustomTextFieldTheme.light,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.notReceive,
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AppStrings.resend,
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      authState.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Column(
                          children: [
                            CustomButton(
                              height: AppSizes.screenHeight(context) * 0.07,
                              text: AppStrings.verify.toUpperCase(),
                              onPressed: _verify,
                              theme: CustomButtonTheme.light,
                            ),
                          ],
                        ),
                        data: (user) => CustomButton(
                          height: AppSizes.screenHeight(context) * 0.07,
                          text: AppStrings.verify.toUpperCase(),
                          onPressed: _verify,
                          theme: CustomButtonTheme.light,
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
