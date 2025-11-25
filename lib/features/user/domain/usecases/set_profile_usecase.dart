import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class SetProfileUseCase {
  final UserRepository _userRepository;

  SetProfileUseCase(this._userRepository);

  Future<void> execute(String? username, String? displayName, String? password) async {
    await _userRepository.setProfile(username, displayName, password);
  }
}