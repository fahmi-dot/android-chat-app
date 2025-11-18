import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class SetUsernameUseCase {
  final AuthRepository _authRepository;

  SetUsernameUseCase(this._authRepository);

  Future<User> execute(String? username, String? displayName, String? password) async {
    return _authRepository.setProfile(username, displayName, password);
  }
}