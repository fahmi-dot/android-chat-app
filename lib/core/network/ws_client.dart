import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:android_chat_app/core/config/env.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';

class WsClient {
  static final WsClient _instance = WsClient._internal();

  factory WsClient() => _instance;

  late StompClient _stompClient;
  final _messageController = StreamController<dynamic>.broadcast();
  final _subscriptions = <String, String>{};
  
  Stream<dynamic> get messageStream => _messageController.stream;
  
  WsClient._internal() {
    _stompClient = StompClient(
      config: StompConfig(
        url: Env.wsBaseUrl,
        reconnectDelay: const Duration(seconds: 5),
        
        onConnect: (StompFrame frame) async {
          final token = await TokenHolder.getAccessToken();
          
          _stompClient.subscribe(
            destination: '/user/queue/messages',
            headers: {'Authorization': 'Bearer $token'},
            callback: (StompFrame frame) {
              final data = jsonDecode(frame.body!);
              final roomId = data['id'];

              if (roomId != null && !_subscriptions.containsKey(roomId)) {
                subscribeToRoom(roomId);
              }
              
              _messageController.add(data);
            },
          );
        },
      ),
    );
  }
  
  void connect() {
    _stompClient.activate();
  }

  void subscribeToRoom(String roomId) {
    if (_subscriptions.containsKey(roomId)) {
      return;
    }
    
    final subscriptionId = _stompClient.subscribe(
      destination: '/topic/messages/$roomId',
      callback: (StompFrame frame) {
        final message = jsonDecode(frame.body!);
        message['type'] = 'message';
        message['id'] = roomId;
        
        _messageController.add(message);
      },
    );
    
    _subscriptions[roomId] = subscriptionId as String;
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
  
  void dispose() {
    _messageController.close();
  }

  void disconnect() {
    _stompClient.deactivate();
    _subscriptions.clear();
  }
}
