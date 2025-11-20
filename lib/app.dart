import 'package:android_chat_app/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState,
      routerConfig: appRouter,
    );
  }
}