import 'package:android_chat_app/features/auth/domain/entities/token.dart';

class TokenModel extends Token {
  const TokenModel({
    required super.access,
    required super.refresh,
    required super.expiryAt,
  });

  factory TokenModel.fromEntity(Token token) {
    return TokenModel(
      access: token.access,
      refresh: token.refresh,
      expiryAt: token.expiryAt,
    );
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      access: json['accessToken'], 
      refresh: json['refreshToken'],
      expiryAt: DateTime.parse(json['expiryAt']),
    );
  }

  Token toEntity() {
    return Token(
      access: access,
      refresh: refresh,
      expiryAt: expiryAt, 
    );
  }

}
