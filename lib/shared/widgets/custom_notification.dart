import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

void showCustomNotification(
  BuildContext context,
  HeroIcons icon,
  String message,
) {
  Flushbar(
    icon: HeroIcon(icon, color: Theme.of(context).colorScheme.onError),
    message: message,
    margin: EdgeInsets.symmetric(vertical: AppSizes.paddingM, horizontal: 32.0),
    backgroundColor: Theme.of(context).colorScheme.error,
    borderRadius: BorderRadius.circular(AppSizes.radiusM),
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: 2),
  ).show(context);
}
