import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class SetMyProfileUseCase {
  final UserRepository _userRepository;

  SetMyProfileUseCase(this._userRepository);

  Future<void> execute(String id, String? username, String? displayName, String? password) async {
    await _userRepository.setMyProfile(id, username, displayName, password);
  }
}