import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth/auth_user.dart';
import '../../data/repositories/auth/auth_repository.dart';
import 'login_cubit.dart' show FormStatus;

class SignupState extends Equatable {
  const SignupState({
    this.status = FormStatus.idle,
    this.errorMessage,
    this.user,
  });

  final FormStatus status;
  final String? errorMessage;
  final AuthUser? user;

  SignupState copyWith({
    FormStatus? status,
    String? errorMessage,
    AuthUser? user,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user];
}

/// Drives the Signup screen's form submission. Same shape as [LoginCubit]
/// (validate → submit → success/failure); kept as a separate cubit rather
/// than one shared "auth form" cubit because the two screens validate
/// different fields (name, confirm-password, terms) and that would
/// otherwise leak into a single class via a pile of nullable/unused fields.
class SignupCubit extends Cubit<SignupState> {
  SignupCubit({this.repository = const MockAuthRepository()})
    : super(const SignupState());

  final AuthRepository repository;

  Future<void> submit({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) async {
    final validationError = _validate(
      name,
      email,
      password,
      confirmPassword,
      acceptedTerms,
    );
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
      final user = await repository.signUp(
        name: name.trim(),
        email: email.trim(),
        password: password,
      );
      if (isClosed) return;
      emit(state.copyWith(status: FormStatus.success, user: user));
    } on AuthException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: FormStatus.failure, errorMessage: e.message));
    }
  }

  String? _validate(
    String name,
    String email,
    String password,
    String confirmPassword,
    bool acceptedTerms,
  ) {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (name.trim().isEmpty) return 'Enter your name.';
    if (!emailPattern.hasMatch(email.trim())) {
      return 'Enter a valid email address.';
    }
    if (password.length < 8) return 'Password must be at least 8 characters.';
    if (password != confirmPassword) return 'Passwords do not match.';
    if (!acceptedTerms) return 'You must accept the Terms to continue.';
    return null;
  }
}
