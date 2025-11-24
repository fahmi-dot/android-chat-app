import 'package:android_chat_app/features/auth/domain/entities/token.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyUseCase {
  final AuthRepository _authRepository;

  VerifyUseCase(this._authRepository);

  Future<Token> execute(String phoneNumber, String verificationCode, String password) async {
    return await _authRepository.verify(phoneNumber, verificationCode, password);
  }
}