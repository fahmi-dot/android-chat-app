import 'package:android_chat_app/features/auth/domain/entities/user.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class CheckUsecase {
  final AuthRepository _authRepository;

  CheckUsecase(this._authRepository);
  
  Future<User?> execute() {
    return _authRepository.check();
  }
}