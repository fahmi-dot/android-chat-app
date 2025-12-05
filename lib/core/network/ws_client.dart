// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:android_chat_app/core/config/env.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';

class WsClient {
  static final WsClient _instance = WsClient._internal();
  factory WsClient() => _instance;
  WsClient._internal();

  late StompClient _stompClient;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  bool _isConnected = false;
  bool _isInitialized = false;
  bool _isSubscribed = false;

  bool get isConnected => _isConnected;
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Function(Map<String, dynamic>)? onMessage;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    
    connect();
  }

  Future<void> connect() async {
    final token = await TokenHolder.getAccessToken();

    _stompClient = StompClient(
      config: StompConfig(
        url: Env.wsBaseUrl,
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) {
          print('WebSocket error: $error');
        },
        onStompError: (StompFrame frame) {
          print('STOMP error: ${frame.body}');
        },
        onDisconnect: (frame) {
          print('Disconnected');
          _isConnected = false;

          Future.delayed(Duration(seconds: 5), () {
            if (_isInitialized) {
              print('Attempting to reconnect...');
              _stompClient.activate();
            }
          });
        },
        beforeConnect: () async {
          print('Connecting...');
        },
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    print('Connected to STOMP');
    _isConnected = true;

    _subscribeToUserQueue();
  }

  void subscribeToUserQueue() {
    _subscribeToUserQueue();
  }

  void _subscribeToUserQueue() {
    if (_isSubscribed) return;
    _isSubscribed = true;

    try {
      print('Subscribing to /user/queue/notifications');

      _stompClient.subscribe(
        destination: '/user/queue/notifications',
        callback: (StompFrame frame) {
          print('Received notification: ${frame.body}');

          if (frame.body == null || frame.body!.isEmpty) return;

          final data = jsonDecode(frame.body!) as Map<String, dynamic>;

          try {
            final message = data;

            _messageController.add(message);
            onMessage?.call(data);
          } catch (e) {
            print('Error parsing message: $e');
          }
        },
      );
    } catch (e) {
      print('Failed to subscribe to user queue: $e');
    }
  }

  void sendMessage({
    String? roomId,
    required String content,
    String? receiver,
  }) {
    if (!_isConnected) return;

    try {
      final message = {
        if (roomId != null) 'roomId': roomId,
        'content': content,
        if (receiver != null) 'receiver': receiver,
      };

      _stompClient.send(
        destination: '/app/chat/send',
        body: jsonEncode(message),
      );

      print('Message sent: $message');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void disconnect() {
    _isConnected = false;
    _isInitialized = false;
    _isSubscribed = false;
    _stompClient.deactivate();
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
