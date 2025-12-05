import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:android_chat_app/core/router/app_router.dart';
import 'package:android_chat_app/core/theme/app_theme.dart';
import 'package:android_chat_app/shared/providers/client_provider.dart';
import 'package:android_chat_app/shared/providers/theme_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    super.initState();
    
    Future.microtask(() async {
      final token = await TokenHolder.getAccessToken();

      if (token != null) {
        final success = await ref.read(authProvider.notifier).refresh();

        if (success) ref.read(wsClientProvider).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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