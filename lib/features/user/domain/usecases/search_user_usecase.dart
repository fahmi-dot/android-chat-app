import 'package:android_chat_app/features/user/domain/entities/user_summary.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class SearchUserUseCase {
  final UserRepository _userRepository;

  SearchUserUseCase(this._userRepository);

  Future<List<UserSummary>> execute(String key) async {
    return await _userRepository.searchUser(key);
  }
}