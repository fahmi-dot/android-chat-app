import 'package:android_chat_app/features/auth/presentation/screens/change_email_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/register_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/set_username_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/verify_screen.dart';
import 'package:android_chat_app/features/user/presentation/screens/my_profile_screen.dart';
import 'package:android_chat_app/features/user/presentation/screens/search_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:android_chat_app/features/auth/presentation/screens/login_screen.dart';
import 'package:android_chat_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:android_chat_app/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:android_chat_app/features/chat/presentation/screens/chat_room_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgot = '/forgot';
  static const verify = '/verify/:phoneNumber';
  static const changeEmail = '/change/email';
  static const setUsername = '/set/username';
  static const chatList = '/chats';
  static const chatRoom = '/chats/:username';
  static const searchUser = '/user/search';
  static const myProfile = '/profile';

  static String verifyWithPhone(String phoneNumber) => '/verify/$phoneNumber';
  static String chatWithRoom(String username) => '/chats/$username';
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
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: LoginScreen(),
          transitionsBuilder: (context, animation, secondary, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 250),
        );
      },
    ),
    GoRoute(
      path: Routes.register,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: RegisterScreen(),
          transitionsBuilder: (context, animation, secondary, child) {
            final slide =
                Tween<Offset>(
                  begin: Offset(1, 0), // mulai dari kanan
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );

            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: Duration(milliseconds: 250),
        );
      },
    ),
    GoRoute(
      path: Routes.forgot,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondary, child) {
            final slide = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );

            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: Duration(milliseconds: 250),
        );
      },
    ),
    GoRoute(
      path: Routes.verify,
      pageBuilder: (context, state) {
        final phoneNumber = state.pathParameters['phoneNumber']!;
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          child: VerifyScreen(
            phoneNumber: phoneNumber,
            email: extra['email'],
            password: extra['password'],
          ),
          transitionsBuilder: (context, animation, secondary, child) {
            final slide = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );

            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: Duration(milliseconds: 250),
        );
      },
    ),
    GoRoute(
      path: Routes.changeEmail,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          child: ChangeEmailScreen(
            phoneNumber: extra['phoneNumber'],
            email: extra['email'],
            password: extra['password'],
          ),
          transitionsBuilder: (context, animation, secondary, child) {
            final slide = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                );

            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: Duration(milliseconds: 250),
        );
      },
    ),
    GoRoute(
      path: Routes.setUsername,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          child: SetUsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 250),
        );
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return child;
      },
      routes: [
        GoRoute(
          path: Routes.chatList,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: ChatListScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: Duration(milliseconds: 250),
            );
          },
        ),
        GoRoute(
          path: Routes.chatRoom,
          pageBuilder: (context, state) {
            final username = state.pathParameters['username']!;
            return CustomTransitionPage(
              child: ChatRoomScreen(
                username: username,
              ),
              transitionsBuilder: (context, animation, secondary, child) {
                final slide = Tween<Offset>(begin: Offset(0.1, 0), end: Offset.zero)
                    .animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    );

                return SlideTransition(position: slide, child: child);
              },
              transitionDuration: Duration(milliseconds: 250),
            );
          },
        ),
        GoRoute(
          path: Routes.searchUser,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: SearchUserScreen(),
              transitionsBuilder: (context, animation, secondary, child) {
                final fade = Tween<double>(begin: 0, end: 1).animate(animation);
                final slide = Tween<Offset>(
                  begin: Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(animation);

                return FadeTransition(
                  opacity: fade,
                  child: SlideTransition(position: slide, child: child),
                );
              },
              transitionDuration: Duration(milliseconds: 250),
            );
          },
        ),
        GoRoute(
          path: Routes.myProfile,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              child: MyProfileScreen(),
              transitionsBuilder: (context, animation, secondary, child) {
                final slide = Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
                    .animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    );

                return SlideTransition(position: slide, child: child);
              },
              transitionDuration: Duration(milliseconds: 250),
            );
          },
        )
      ]
    ),
  ],
);
