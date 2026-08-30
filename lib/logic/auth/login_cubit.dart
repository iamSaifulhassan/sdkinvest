import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth/auth_user.dart';
import '../../data/repositories/auth/auth_repository.dart';

enum FormStatus { idle, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = FormStatus.idle,
    this.errorMessage,
    this.user,
  });

  final FormStatus status;
  final String? errorMessage;

  /// Set once [status] is [FormStatus.success] — the page reads this to
  /// hand off to the app-level [AuthCubit].
  final AuthUser? user;

  // Note: unlike this app's other copyWiths, `errorMessage` here is NOT
  // preserved when omitted — every call site below explicitly decides
  // whether an error should carry over, so a stale message never lingers
  // into a later submitting/success state.
  LoginState copyWith({
    FormStatus? status,
    String? errorMessage,
    AuthUser? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user];
}

/// Drives the Login screen's form submission — client-side validation, the
/// [AuthRepository] call, and the loading/error state around it. Does not
/// touch app-wide session state directly; the page listens for
/// [FormStatus.success] and forwards the result to [AuthCubit].
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({this.repository = const MockAuthRepository()})
    : super(const LoginState());

  final AuthRepository repository;

  Future<void> submit({required String email, required String password}) async {
    final validationError = _validate(email, password);
    if (validationError != null) {
      emit(
        state.copyWith(
          status: FormStatus.failure,
          errorMessage: validationError,
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormStatus.submitting));
    try {
      final user = await repository.signIn(email: email, password: password);
      if (isClosed) return;
      emit(state.copyWith(status: FormStatus.success, user: user));
    } on AuthException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: FormStatus.failure, errorMessage: e.message));
    }
  }

  String? _validate(String email, String password) {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email.trim())) {
      return 'Enter a valid email address.';
    }
    if (password.isEmpty) return 'Enter your password.';
    return null;
  }
}
