import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/login_cubit.dart' show FormStatus;

/// Sentinel so [ProfileState.copyWith] can tell "avatarBytes not passed"
/// (keep the current value) apart from "explicitly passed null" (clear it).
const _unset = Object();

class ProfileState extends Equatable {
  const ProfileState({
    this.status = FormStatus.idle,
    this.errorMessage,
    this.avatarBytes,
  });

  final FormStatus status;
  final String? errorMessage;

  /// The picked profile photo, held in memory only — there's no backend
  /// yet to upload it to, so (like the rest of this screen's mock actions)
  /// it doesn't survive an app restart.
  final Uint8List? avatarBytes;

  ProfileState copyWith({
    FormStatus? status,
    String? errorMessage,
    Object? avatarBytes = _unset,
  }) {
    return ProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      avatarBytes: identical(avatarBytes, _unset)
          ? this.avatarBytes
          : avatarBytes as Uint8List?,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, avatarBytes];
}

/// Drives the Profile screen's change-password form and avatar picker. No
/// backend yet — validates client-side and mocks the round trip, same
/// convention as [LoginCubit]/[SignupCubit].
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

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final error = _validate(currentPassword, newPassword, confirmPassword);
    if (error != null) {
      emit(state.copyWith(status: FormStatus.failure, errorMessage: error));
      return;
    }

    emit(state.copyWith(status: FormStatus.submitting));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    // No backend yet to verify `currentPassword` against, so — unlike the
    // length/match checks above — this can't actually fail here. A real
    // implementation would surface an "incorrect password" error from the
    // API at this point instead of always succeeding.
    emit(state.copyWith(status: FormStatus.success, errorMessage: null));
  }

  String? _validate(
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
