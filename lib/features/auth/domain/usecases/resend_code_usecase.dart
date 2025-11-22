import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class ResendCodeUseCase {
  final AuthRepository _authRepository;

  ResendCodeUseCase(this._authRepository);

  Future<void> execute(String phoneNumber) {
    return _authRepository.resendCode(phoneNumber);
  }
}