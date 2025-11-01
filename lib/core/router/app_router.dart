import 'package:go_router/go_router.dart';
import 'package:android_chat_app/features/auth/presentation/screens/login_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:android_chat_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:android_chat_app/features/chat/presentation/screens/chat_room_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const chatList = '/chats';
  static const chatRoom = '/chats/:roomId';
}

final appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.chatList,
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: Routes.chatRoom,
      builder: (context, state) => const ChatRoomScreen(),
      // builder: (context, state) {
      //   final roomId = state.pathParameters['roomId']!;
      //   return ChatRoomScreen(roomId: roomId);
      // },
    ),
  ],
);