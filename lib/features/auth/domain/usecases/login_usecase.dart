import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Auth> execute(String username, String password) {
    return _authRepository.login(username, password);
  }
}