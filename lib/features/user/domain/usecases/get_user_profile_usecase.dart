import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository _userRepository;

  GetUserProfileUseCase(this._userRepository);

  Future<UserSummary> execute(String username) async {
    return await _userRepository.getUserProfile(username);
  }
}