import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WsClient().initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    )
  );
}