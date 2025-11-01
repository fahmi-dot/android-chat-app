import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String username;
  final String displayName;
  final String phoneNumber;
  final String avatarUrl;
  final String? bio;

  const Auth({
    required this.username,
    required this.displayName,
    required this.phoneNumber,
    required this.avatarUrl,
    required this.bio,
  });

  Auth copyWith({
    String? username,
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
    String? bio,
  }) {
    return Auth(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object?> get props => [
    username,
    displayName,
    phoneNumber,
    avatarUrl,
    bio,
  ];
}
