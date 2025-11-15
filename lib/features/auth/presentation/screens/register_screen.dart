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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
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
                      CustomBanner(icon: HeroIcons.identification),
                      const SizedBox(height: 32.0),
                      Text(
                        AppStrings.registerTitle,
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
                        controller: _phoneNumberController,
                        hintText: AppStrings.phoneNumber,
                        fontSize: AppSizes.fontL,
                        maxLines: 1,
                        type: CustomTextFieldType.text,
                        theme: CustomTextFieldTheme.light,
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      CustomTextField(
                        height: AppSizes.screenHeight(context) * 0.07,
                        radius: AppSizes.radiusXXL,
                        controller: _emailController,
                        hintText: AppStrings.email,
                        fontSize: AppSizes.fontL,
                        maxLines: 1,
                        type: CustomTextFieldType.text,
                        theme: CustomTextFieldTheme.light,
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      CustomTextField(
                        height: AppSizes.screenHeight(context) * 0.07,
                        radius: AppSizes.radiusXXL,
                        controller: _usernameController,
                        hintText: AppStrings.username,
                        fontSize: AppSizes.fontL,
                        maxLines: 1,
                        type: CustomTextFieldType.text,
                        theme: CustomTextFieldTheme.light,
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
                        theme: CustomTextFieldTheme.light,
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      CustomTextField(
                        height: AppSizes.screenHeight(context) * 0.07,
                        radius: AppSizes.radiusXXL,
                        controller: _cPasswordController,
                        hintText: AppStrings.cPassword,
                        fontSize: AppSizes.fontL,
                        maxLines: 1,
                        type: CustomTextFieldType.password,
                        theme: CustomTextFieldTheme.light,
                      ),
                      const SizedBox(height: 32.0),
                      authState.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (e, _) => Column(
                          children: [
                            CustomButton(
                              height: AppSizes.screenHeight(context) * 0.07,
                              text: AppStrings.register.toUpperCase(),
                              onPressed: () => context.push(
                                '/verify/${_emailController.text}',
                              ),
                              theme: CustomButtonTheme.light,
                            ),
                            SizedBox(height: AppSizes.paddingS),
                            Text(
                              '$e',
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                        data: (user) => CustomButton(
                          height: AppSizes.screenHeight(context) * 0.07,
                          text: AppStrings.register.toUpperCase(),
                          onPressed: () => context.push(
                            '/verify/${_phoneNumberController.text}',
                            extra: _emailController.text,
                          ),
                          theme: CustomButtonTheme.light,
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
                  AppStrings.haveAccount,
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    AppStrings.login,
                    style: TextStyle(
                      color: AppColors.secondary,
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
