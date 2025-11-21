import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    this.width,
    this.height,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? AppSizes.screenWidth(context),
      height: height ?? AppSizes.screenHeight(context) * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

enum CustomButtonTheme { light, dark }
