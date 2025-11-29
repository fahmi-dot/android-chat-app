import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class SetMyProfileUseCase {
  final UserRepository _userRepository;

  SetMyProfileUseCase(this._userRepository);

  Future<void> execute(User user) async {
    await _userRepository.setMyProfile(user);
  }
}