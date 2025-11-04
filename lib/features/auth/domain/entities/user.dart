import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String displayName;
  final String phoneNumber;
  final String avatarUrl;
  final String? bio;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.bio,
  });

  User copyWith({
    String? username,
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
    String? bio,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    displayName,
    phoneNumber,
    avatarUrl,
    bio,
  ];
}
