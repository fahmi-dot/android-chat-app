import 'package:android_chat_app/shared/widgets/custom_notification.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

void showCustomOnWorkingNotification(
  BuildContext context
) {
  showCustomNotification(
    context, 
    HeroIcons.exclamationTriangle, 
    'Feature still on working',
    CustomNotificationType.warning
  );
}