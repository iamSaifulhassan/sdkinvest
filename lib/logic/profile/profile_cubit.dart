import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/auth/auth_user.dart';
import '../auth/login_cubit.dart' show FormStatus;

/// Sentinel so [ProfileState.copyWith] can tell "avatarBytes not passed"
/// (keep the current value) apart from "explicitly passed null" (clear it).
const _unset = Object();

class ProfileState extends Equatable {
  const ProfileState({
    this.passwordStatus = FormStatus.idle,
    this.passwordError,
    this.profileStatus = FormStatus.idle,
    this.profileError,
    this.savedUser,
    this.avatarBytes,
  });

  /// Change-password form.
  final FormStatus passwordStatus;
  final String? passwordError;

  /// Personal-information (name/email) form. Tracked separately from the
  /// password form so submitting one doesn't put the other into a loading
  /// or error state.
  final FormStatus profileStatus;
  final String? profileError;

  /// Set once [profileStatus] is [FormStatus.success] — the page reads this
  /// to hand the updated details off to the app-level [AuthCubit], the same
  /// way [LoginCubit] hands off its signed-in user.
  final AuthUser? savedUser;

  /// The picked profile photo, held in memory only — there's no backend
  /// yet to upload it to, so (like the rest of this screen's mock actions)
  /// it doesn't survive an app restart.
  final Uint8List? avatarBytes;

  ProfileState copyWith({
    FormStatus? passwordStatus,
    String? passwordError,
    FormStatus? profileStatus,
    String? profileError,
    AuthUser? savedUser,
    Object? avatarBytes = _unset,
  }) {
    return ProfileState(
      passwordStatus: passwordStatus ?? this.passwordStatus,
      passwordError: passwordError,
      profileStatus: profileStatus ?? this.profileStatus,
      profileError: profileError,
      savedUser: savedUser ?? this.savedUser,
      avatarBytes: identical(avatarBytes, _unset)
          ? this.avatarBytes
          : avatarBytes as Uint8List?,
    );
  }

  @override
  List<Object?> get props => [
    passwordStatus,
    passwordError,
    profileStatus,
    profileError,
    savedUser,
    avatarBytes,
  ];
}

/// Drives the Profile screen's personal-information form, change-password
/// form, and avatar picker. No backend yet — validates client-side and
/// mocks the round trip, same convention as [LoginCubit]/[SignupCubit].
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker(),
      super(const ProfileState());

  final ImagePicker _imagePicker;

  Future<void> pickAvatar(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null || isClosed) return;
    final bytes = await picked.readAsBytes();
    if (isClosed) return;
    emit(state.copyWith(avatarBytes: bytes));
  }

  void removeAvatar() => emit(state.copyWith(avatarBytes: null));

  /// Saves an edited name/email. Emits [FormStatus.success] with the new
  /// [AuthUser] in [ProfileState.savedUser]; the page forwards that to
  /// [AuthCubit] so every screen showing the user's details updates too.
  Future<void> saveProfile({
    required String name,
    required String email,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();

    final error = _validateProfile(trimmedName, trimmedEmail);
    if (error != null) {
      emit(
        state.copyWith(
          profileStatus: FormStatus.failure,
          profileError: error,
          // Keep any password-form error from being cleared by this
          // unrelated submission.
          passwordError: state.passwordError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        profileStatus: FormStatus.submitting,
        passwordError: state.passwordError,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    emit(
      state.copyWith(
        profileStatus: FormStatus.success,
        savedUser: AuthUser(name: trimmedName, email: trimmedEmail),
        passwordError: state.passwordError,
      ),
    );
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final error = _validatePassword(
      currentPassword,
      newPassword,
      confirmPassword,
    );
    if (error != null) {
      emit(
        state.copyWith(
          passwordStatus: FormStatus.failure,
          passwordError: error,
          profileError: state.profileError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        passwordStatus: FormStatus.submitting,
        profileError: state.profileError,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    // No backend yet to verify `currentPassword` against, so — unlike the
    // length/match checks above — this can't actually fail here. A real
    // implementation would surface an "incorrect password" error from the
    // API at this point instead of always succeeding.
    emit(
      state.copyWith(
        passwordStatus: FormStatus.success,
        profileError: state.profileError,
      ),
    );
  }

  String? _validateProfile(String name, String email) {
    if (name.isEmpty) return 'Enter your full name.';
    if (name.length < 2) return 'Enter your full name.';
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email)) return 'Enter a valid email address.';
    return null;
  }

  String? _validatePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) {
    if (currentPassword.isEmpty) return 'Enter your current password.';
    if (newPassword.length < 6) {
      return 'New password must be at least 6 characters.';
    }
    if (newPassword != confirmPassword) return 'Passwords do not match.';
    if (newPassword == currentPassword) {
      return 'New password must be different from your current password.';
    }
    return null;
  }
}
