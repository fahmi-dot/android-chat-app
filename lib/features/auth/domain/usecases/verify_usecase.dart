import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyUseCase {
  final AuthRepository _authRepository;

  VerifyUseCase(this._authRepository);

  Future<User> execute(String phoneNumber, String verificationCode, String password) {
    return _authRepository.verify(phoneNumber, verificationCode, password);
  }
}