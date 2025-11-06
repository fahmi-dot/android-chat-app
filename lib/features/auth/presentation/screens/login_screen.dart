import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_chat_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final success = await ref
        .read(authProvider.notifier)
        .login(username, password);

    if (!mounted) return;

    if (success) {
      context.go('/chats');
    } else {
      ScaffoldMessenger
        .of(context)
        .showSnackBar(const SnackBar(content: Text('Failed to login')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            authState.when(
              data: (user) =>
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Column(
                children: [
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
                  const SizedBox(height: 16),
                  Text('Error: $e', style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
