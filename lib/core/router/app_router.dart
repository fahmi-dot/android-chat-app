import 'package:android_chat_app/features/auth/presentation/screens/change_email_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/register_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/set_username_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/verify_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:android_chat_app/features/auth/presentation/screens/login_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:android_chat_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:android_chat_app/features/chat/presentation/screens/chat_room_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const verify = '/verify/:phoneNumber';
  static const changeEmail = '/change/email';
  static const setUsername = '/set/username';
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
      path: Routes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: Routes.verify,
      builder: (context, state) {
        final phoneNumber = state.pathParameters['phoneNumber']!;
        final extra = state.extra as Map<String, dynamic>;
        return VerifyScreen(
          phoneNumber: phoneNumber,
          email: extra['email'],
          password: extra['password'],
        );
      },
    ),
    GoRoute(
      path: Routes.changeEmail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ChangeEmailScreen(
          phoneNumber: extra['phoneNumber'],
          email: extra['email'],
          password: extra['password'],
        );
      },
    ),
    GoRoute(
      path: Routes.setUsername,
      builder: (context, state) => const SetUsernameScreen(),
    ),
    GoRoute(
      path: Routes.chatList,
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: Routes.chatRoom,
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return ChatRoomScreen(roomId: roomId);
      },
    ),
  ],
);
