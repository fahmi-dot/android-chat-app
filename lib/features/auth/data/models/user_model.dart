import 'package:android_chat_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.displayName,
    required super.phoneNumber,
    required super.avatarUrl,
    required super.bio,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      avatarUrl: user.avatarUrl,
      bio: user.bio,
    );
  }

  User toEntity() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      phoneNumber: phoneNumber,
      avatarUrl: avatarUrl,
      bio: bio,
    );
  }
}
