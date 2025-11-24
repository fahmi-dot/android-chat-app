import 'package:equatable/equatable.dart';

class UserSummary extends Equatable {
  final String username;
  final String displayName;
  final String avatarUrl;

  const UserSummary({
    required this.username,
    required this.displayName,
    required this.avatarUrl,
  });

  UserSummary copyWith({
    String? username,
    String? displayName,
    String? avatarUrl,
  }) {
    return UserSummary(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [username, displayName, avatarUrl];
}
