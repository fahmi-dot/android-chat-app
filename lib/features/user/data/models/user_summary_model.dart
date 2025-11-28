import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';

class UserSummaryModel extends UserSummary {
  const UserSummaryModel({
    required super.username,
    required super.displayName,
    required super.avatarUrl,
  });

  factory UserSummaryModel.fromEntity(UserSummary user) {
    return UserSummaryModel(
      username: user.username,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
    );
  }

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      username: json['username'], 
      displayName: json['displayName'], 
      avatarUrl: json['avatarUrl'],
    );
  }

  UserSummary toEntity() {
    return UserSummary(
      username: username,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}
