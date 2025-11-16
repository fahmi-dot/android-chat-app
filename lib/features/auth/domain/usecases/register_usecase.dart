import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<void> execute(String phoneNumber, String email, String username, String password) {
    return _authRepository.register(phoneNumber, email, username, password);
  }
}