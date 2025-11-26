import 'package:android_chat_app/core/network/api_client.dart';
import 'package:android_chat_app/core/network/ws_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final wsClientProvider = Provider<WsClient>((ref) {
  return WsClient();
});