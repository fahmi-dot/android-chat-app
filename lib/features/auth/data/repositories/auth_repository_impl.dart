import 'package:android_chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:android_chat_app/features/auth/domain/entities/auth.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<Auth> login(String username, String password) async {
    return await authRemoteDataSource.login(username, password);
  }
  
  @override
  Future<Auth> check() async {
    return await authRemoteDataSource.check();
  }
}
