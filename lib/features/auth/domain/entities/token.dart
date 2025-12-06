import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String access;
  final String refresh;
  final DateTime expiryAt;

  const Token({
    required this.access,
    required this.refresh,
    required this.expiryAt,
  });

  @override
  List<Object?> get props => [
    access,
    refresh,
    expiryAt,
  ];
}
