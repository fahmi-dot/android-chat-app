import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

void showCustomNotification(
  BuildContext context,
  HeroIcons icon,
  String message,
  CustomNotificationType type,
) {
  Flushbar(
    icon: HeroIcon(
      icon, 
      color: type == CustomNotificationType.error
          ? Theme.of(context).colorScheme.onError
          : type == CustomNotificationType.warning
          ? Theme.of(context).colorScheme.onErrorContainer
          : Theme.of(context).colorScheme.onTertiary),
    message: message,
    margin: EdgeInsets.symmetric(vertical: AppSizes.paddingM, horizontal: 32.0),
    backgroundColor: type == CustomNotificationType.error
          ? Theme.of(context).colorScheme.error
          : type == CustomNotificationType.warning
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.tertiary,
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: 2),
  ).show(context);
}

enum CustomNotificationType { error, warning, success }