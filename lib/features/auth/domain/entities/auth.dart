import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final bool isLoggedIn;

  const Auth({required this.isLoggedIn});
  
  Auth copyWith({
    bool? isLoggedIn
  }) {
    return Auth(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn
    );
  }

  @override
  List<Object?> get props => [isLoggedIn];  
}