import 'package:android_chat_app/features/auth/domain/entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel({required super.isLoggedIn});

  factory AuthModel.fromEntity(Auth auth) {
    return AuthModel(isLoggedIn: auth.isLoggedIn);
  }

  Auth toEntity() {
    return Auth(isLoggedIn: isLoggedIn);
  }
}
