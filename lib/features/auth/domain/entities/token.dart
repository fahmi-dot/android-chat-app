import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String access;
  final String refresh;

  const Token({
    required this.access,
    required this.refresh,
  });

  @override
  List<Object?> get props => [
    access,
    refresh,
  ];
}
