import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/env.dart';

class WsClient {
  WebSocketChannel? _channel;

  void connect(String token) {
    final uri = Uri.parse('${Env.wsBaseUrl}?token=$token');
    _channel = WebSocketChannel.connect(uri);
  }
  
  Stream get stream => _channel!.stream;
  void send(String message) => _channel!.sink.add(message);
  void dispose() => _channel?.sink.close();
}
