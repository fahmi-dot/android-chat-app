import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class VerifyUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  VerifyUseCase(this._authRepository, this._userRepository);

  Future<User> execute(String phoneNumber, String verificationCode, String password) async {
    await _authRepository.verify(phoneNumber, verificationCode, password);

    return await _userRepository.getProfile();
  }
}