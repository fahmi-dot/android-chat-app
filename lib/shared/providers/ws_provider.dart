import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wsClientProvider = Provider<WsClient>((ref) {
  final ws = WsClient();
  ref.onDispose(ws.dispose);
  return ws;
});