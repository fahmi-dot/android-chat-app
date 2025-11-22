import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:android_chat_app/features/user/domain/entities/user.dart';
import 'package:android_chat_app/features/user/domain/repositories/user_repository.dart';

class CheckUsecase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  CheckUsecase(this._authRepository, this._userRepository);
  
  Future<User?> execute() async {
    final token = await _authRepository.refresh();
    
    if (token == null) return null;

    return await _userRepository.getProfile();
  }
}