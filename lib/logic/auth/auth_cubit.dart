import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth/auth_user.dart';

enum AuthStatus {
  /// First-launch carousel hasn't been dismissed yet.
  onboarding,

  /// Onboarding is done but no one is signed in — shows Login/Signup.
  unauthenticated,

  /// A user is signed in — shows the main app.
  authenticated,
}

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.onboarding, this.user});

  final AuthStatus status;
  final AuthUser? user;

  @override
  List<Object?> get props => [status, user];
}

/// Root session state for the whole app. This is the one cubit that
/// legitimately lives above the router (provided once in `main.dart`) —
/// every screen-level cubit is scoped to its own page. `AuthGate` in
/// main.dart watches this to decide whether to show Onboarding, Login, or
/// the main app shell.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void completeOnboarding() =>
      emit(const AuthState(status: AuthStatus.unauthenticated));

  /// Called by Login/Signup once their own cubit reports success — this
  /// cubit doesn't talk to [AuthRepository] itself, it just records the
  /// outcome other cubits already validated.
  void signedIn(AuthUser user) =>
      emit(AuthState(status: AuthStatus.authenticated, user: user));

  /// Applies edits made on the Profile screen to the live session so every
  /// screen reading `state.user` picks up the new name/email. Ignored when
  /// no one is signed in — there'd be no session to update.
  void profileUpdated(AuthUser user) {
    if (state.status != AuthStatus.authenticated) return;
    emit(AuthState(status: AuthStatus.authenticated, user: user));
  }

  void signOut() => emit(const AuthState(status: AuthStatus.unauthenticated));
}
