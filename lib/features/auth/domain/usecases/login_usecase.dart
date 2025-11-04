import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<User> execute(String username, String password) {
    return _authRepository.login(username, password);
  }
}