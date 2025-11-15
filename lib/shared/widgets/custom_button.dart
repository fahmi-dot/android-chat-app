import 'package:android_chat_app/core/constants/app_colors.dart';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final VoidCallback onPressed;
  final CustomButtonTheme theme;

  const CustomButton({
    super.key,
    this.width,
    required this.text,
    required this.height,
    required this.onPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppSizes.screenWidth(context),
      height: height ?? AppSizes.screenHeight(context),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        child: Text(
          text,
          style: TextStyle(
            fontSize: AppSizes.fontL,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

enum CustomButtonTheme { light, dark }
