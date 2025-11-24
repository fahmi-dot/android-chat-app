import 'package:android_chat_app/features/auth/domain/entities/token.dart';
import 'package:android_chat_app/features/auth/domain/repositories/auth_repository.dart';

class CheckUsecase {
  final AuthRepository _authRepository;

  CheckUsecase(this._authRepository);
  
  Future<Token?> execute() async {
    return await _authRepository.refresh();
  }
}