import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:android_chat_app/core/config/env.dart';
import 'package:android_chat_app/core/utils/token_holder.dart';

class WsClient {
  late StompClient _stompClient;

  void connect({required String roomId}) async {
    final token = await TokenHolder.getAccessToken();
    _stompClient = StompClient(
      config: StompConfig(
        url: Env.wsBaseUrl,
        onConnect: (frame) => onConnect(frame, roomId: roomId),
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );

    _stompClient.activate();
  }

  void onConnect(StompFrame frame, {required String roomId}) {
    _stompClient.subscribe(
      destination: '/topic/messages/$roomId',
      callback: (frame) {
        print('📩 Pesan baru: ${frame.body}');
      },
    );
  }

  void sendMessage(String roomId, String message) {
    _stompClient.send(
      destination: '/app/chat/$roomId',
      body: '{"content": "$message"}',
    );
  }

  void disconnect() {
    _stompClient.deactivate();
  }
}
