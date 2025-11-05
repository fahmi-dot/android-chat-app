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

  final Map<String, Function> _subscriptions = {};
  final Set<String> _pendingSubscriptions = {};

  bool _isConnected = false;
  bool _isInitialized = false;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

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

    if (_pendingSubscriptions.isNotEmpty) {
      print('Processing ${_pendingSubscriptions.length} pending subscriptions');
      final pending = List<String>.from(_pendingSubscriptions);

      for (final roomId in pending) {
        _performSubscription(roomId);
      }
      _pendingSubscriptions.clear();
    }
  }

  void subscribeToRoom(String roomId) {
    if (_subscriptions.containsKey(roomId)) {
      print('Already subscribed to room: $roomId');
      return;
    }

    if (!_isConnected) {
      print('STOMP client not connected yet, adding room $roomId to pending');
      _pendingSubscriptions.add(roomId);
      return;
    }

    _performSubscription(roomId);
  }

  void _performSubscription(String roomId) {
    try {
      print('Subscribing to room: $roomId');

      final subscription = _stompClient.subscribe(
        destination: '/topic/messages/$roomId',
        callback: (StompFrame frame) {
          print('Received frame for room $roomId: ${frame.body}');

          if (frame.body == null || frame.body!.isEmpty) return;

          try {
            final message = jsonDecode(frame.body!) as Map<String, dynamic>;
            
            _messageController.add(message);
          } catch (e) {
            print('Error: $e');
          }
        },
      );

      if (subscription != null) {
        _subscriptions[roomId] = subscription;
        print('Successfully subscribed to room: $roomId');
      } else {
        print('Failed to subscribe');
      }
    } catch (e) {
      print('Error subscribing to room $roomId: $e');
    }
  }

  void sendMessage(
    String? roomId,
    String content,
    String? receiver,
  ) {
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
    _subscriptions.clear();
    _pendingSubscriptions.clear();
    _isConnected = false;
    _stompClient.deactivate();
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
