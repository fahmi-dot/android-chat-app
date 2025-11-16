import 'package:android_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<User> login(String username, String password) async {
    return await authRemoteDataSource.login(username, password);
  }
  
  @override
  Future<void> register(String phoneNumber, String email, String username, String password) async {
    return await authRemoteDataSource.register(phoneNumber, email, username, password); 
  }
  
  @override
  Future<void> verify(String phoneNumber, String verificationCode) async {
    return await authRemoteDataSource.verify(phoneNumber, verificationCode);
  }

  @override
  Future<User?> check() async {
    return await authRemoteDataSource.check();
  }
}
