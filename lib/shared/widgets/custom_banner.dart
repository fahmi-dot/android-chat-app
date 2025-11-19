import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class CustomBanner extends StatelessWidget {
  final HeroIcons icon;
  const CustomBanner({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            ),
            padding: EdgeInsets.all(32.0),
            child: HeroIcon(
              icon,
              style: HeroIconStyle.outline,
              color: Theme.of(context).colorScheme.primary,
              size: 80.0,
            ),
          ),
        ),
        Positioned(
          left: 35,
          bottom: 10,
          child: Container(
            width: AppSizes.iconL * 2,
            height: AppSizes.iconL * 2,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          left: 75,
          top: 0,
          child: Container(
            width: AppSizes.iconXS,
            height: AppSizes.iconXS,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: 50,
          bottom: 50,
          child: Container(
            width: AppSizes.iconXL,
            height: AppSizes.iconXL,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
