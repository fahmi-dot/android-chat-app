import 'package:android_chat_app/core/utils/token_holder.dart';
import 'package:android_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:android_chat_app/features/auth/data/models/token_model.dart';
import 'package:android_chat_app/features/auth/domain/entities/token.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Token> login(String username, String password) async {
    final tokenModel = await authRemoteDataSource.login(username, password);
    
    return saveTokens(tokenModel);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await authRemoteDataSource.forgotPassword(email);
  }
  
  @override
  Future<void> register(String phoneNumber, String email, String password) async {
    await authRemoteDataSource.register(phoneNumber, email, password); 
  }

  @override
  Future<void> resendCode(String phoneNumber) async {
    await authRemoteDataSource.resendCode(phoneNumber);
  }
  
  @override
  Future<Token> verify(String phoneNumber, String verificationCode, String password) async {
    final tokenModel = await authRemoteDataSource.verify(phoneNumber, verificationCode, password);
    
    return saveTokens(tokenModel);
  }

  @override
  Future<Token?> refresh() async {
    final refreshToken = await TokenHolder.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await TokenHolder.deleteTokens();
      return null;
    }

    final tokenModel = await authRemoteDataSource.refresh(refreshToken);
    
    return saveTokens(tokenModel!);
  }

  Future<Token> saveTokens(TokenModel tokenModel) async {
    await TokenHolder.saveTokens(
        accessToken: tokenModel.access,
        refreshToken: tokenModel.refresh,
    );

    return tokenModel.toEntity();
  }
}
