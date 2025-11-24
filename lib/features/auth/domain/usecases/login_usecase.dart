import 'package:android_chat_app/features/auth/domain/entities/token.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Token> execute(String username, String password) async {
    return await _authRepository.login(username, password);
  }
}