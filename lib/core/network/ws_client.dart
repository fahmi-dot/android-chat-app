import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:android_chat_app/core/config/env.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';

class WsClient {
  static final WsClient _instance = WsClient._internal();

  factory WsClient() => _instance;
  WsClient._internal();

  late final StompClient _stompClient;
  bool _connected = false;

  Future<void> connect() async {
    if (_connected) return;
    final token = await TokenHolder.getAccessToken();

    _stompClient = StompClient(
      config: StompConfig(
        url: Env.wsBaseUrl,
        onConnect: onConnect,
        onWebSocketError: (e) => Exception('WebSocket error: $e'),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _stompClient.activate();
  }

  void onConnect(StompFrame frame) {
    _connected = true;

    _stompClient.subscribe(
      destination: '/user/queue/notifications',
      callback: (frame) {
        print('Pesan baru: ${frame.body}');
      },
    );
  }

  void subscribeToRoom(String roomId) {
    _stompClient.subscribe(
      destination: '/topic/messages/$roomId',
      callback: (frame) {
        print('Pesan baru di room $roomId: ${frame.body}');
      },
    );
  }

  void sendMessage({
    String? roomId,
    required String receiver,
    required String message,
  }) {
    final body = jsonEncode({
      'roomId': roomId ?? '',
      'receiver': receiver,
      'content': message,
    });
    _stompClient.send(destination: '/app/chat/send', body: body);
  }

  void disconnect() {
    _connected = false;

    _stompClient.deactivate();
  }
}
