import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class GetProfileUseCase {
  final UserRepository _userRepository;

  GetProfileUseCase(this._userRepository);

  Future<User> execute() async {
    return await _userRepository.getProfile();
  }
}