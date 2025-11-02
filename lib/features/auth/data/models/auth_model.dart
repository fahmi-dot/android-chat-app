import 'package:android_chat_app/features/auth/domain/entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel({
    required super.id,
    required super.username,
    required super.displayName,
    required super.phoneNumber,
    required super.avatarUrl,
    required super.bio,
  });

  factory AuthModel.fromEntity(Auth auth) {
    return AuthModel(
      id: auth.id,
      username: auth.username,
      displayName: auth.displayName,
      phoneNumber: auth.phoneNumber,
      avatarUrl: auth.avatarUrl,
      bio: auth.bio,
    );
  }

  Auth toEntity() {
    return Auth(
      id: id,
      username: username,
      displayName: displayName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      bio: bio,
    );
  }
}
