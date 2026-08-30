import 'package:equatable/equatable.dart';

/// The signed-in user. Minimal on purpose — extend as real account data
/// (avatar, plan tier, etc.) becomes available from a backend.
class AuthUser extends Equatable {
  const AuthUser({required this.name, required this.email});

  final String name;
  final String email;

  @override
  List<Object?> get props => [name, email];
}
