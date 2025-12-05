import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> execute() async {
    await _authRepository.logout();
  }
}