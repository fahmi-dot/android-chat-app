import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyUseCase {
  final AuthRepository _authRepository;

  VerifyUseCase(this._authRepository);

  Future<void> execute(String phoneNumber, String verificationCode) {
    return _authRepository.verify(phoneNumber, verificationCode);
  }
}