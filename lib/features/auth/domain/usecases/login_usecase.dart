import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  LoginUseCase(this._authRepository, this._userRepository);

  Future<User> execute(String username, String password) async {
    await _authRepository.login(username, password);

    return await _userRepository.getProfile();
  }
}