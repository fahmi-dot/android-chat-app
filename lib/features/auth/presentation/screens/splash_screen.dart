import 'dart:async';
import 'package:android_chat_app/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_hasNavigated) return;

    try {
      final auth = await ref.read(authProvider.future);

      if (!mounted) return;
      _hasNavigated = true;

      (auth != null) ? context.go('/chats') : context.go('/login');
    } catch (e) {
      if (!mounted) return;
      _hasNavigated = true;

      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/icons/icon_hello.png',
            width: AppSizes.screenWidth(context) * 0.5,
          ),
        ),
      ),
    );
  }
}
