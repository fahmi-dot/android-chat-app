import 'package:android_chat_app/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.displayName,
    required super.phoneNumber,
    required super.email,
    required super.avatarUrl,
    required super.bio,
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      email: user.email,
      avatarUrl: user.avatarUrl,
      bio: user.bio,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'], 
      displayName: json['displayName'], 
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      avatarUrl: json['avatarUrl'], 
      bio: json['bio'],
    );
  }

  User toEntity() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      phoneNumber: phoneNumber,
      email: email,
      avatarUrl: avatarUrl,
      bio: bio,
    );
  }
}
