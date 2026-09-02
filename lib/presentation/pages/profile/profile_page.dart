import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/auth/login_cubit.dart' show FormStatus;
import '../../../logic/profile/profile_cubit.dart';
import '../../widgets/common/app_bottom_nav.dart';
import '../../widgets/common/app_brand_logo.dart';
import '../../widgets/common/app_feedback.dart';
import '../../widgets/common/app_primary_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/theme_toggle_button.dart';

/// Profile screen — account summary, subscription status, personal info,
/// change-password form, and account deletion.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.lg,
        title: const AppBrandLogo(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.alerts),
          ),
          // No ProfileAvatarButton here — it would just navigate to this
          // same screen, and the space is needed (this page has a back
          // button, unlike the tab roots ProfileAvatarButton appears on).
          const ThemeToggleButton(),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.status == FormStatus.success) {
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
              AppFeedback.showSnackBar(context, 'Password updated.');
            } else if (state.status == FormStatus.failure &&
                state.errorMessage != null) {
              AppFeedback.showSnackBar(context, state.errorMessage!);
            }
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            children: [
              Text('My Profile', style: AppTextStyles.headline.copyWith(fontSize: 26)),
              const SizedBox(height: 4),
              Text(
                'Manage your personal information and account security.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.xl),
              _SectionCard(
                child: Column(
                  children: [
                    BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen: (previous, current) =>
                          previous.avatarBytes != current.avatarBytes,
                      builder: (context, state) {
                        final avatarBytes = state.avatarBytes;
                        return GestureDetector(
                          onTap: () => _showAvatarSheet(context, avatarBytes),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.accentBlue,
                                    ),
                                    image: avatarBytes == null
                                        ? null
                                        : DecorationImage(
                                            image: MemoryImage(avatarBytes),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  padding: avatarBytes == null
                                      ? const EdgeInsets.all(18)
                                      : EdgeInsets.zero,
                                  child: avatarBytes == null
                                      ? Icon(
                                          Icons.person_outline_rounded,
                                          size: 36,
                                          color: AppColors.accentBlue,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.accentBlue,
                                    border: Border.all(
                                      color: AppColors.surface,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      user?.name ?? 'Guest',
                      style: AppTextStyles.title.copyWith(fontSize: 17),
                    ),
                    Text(
                      user?.email ?? '—',
                      style: AppTextStyles.caption.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUBSCRIPTION',
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card_rounded,
                          size: 18,
                          color: AppColors.accentBlue,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Free Plan',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.strongBuy.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Active',
                            style: AppTextStyles.badge.copyWith(
                              fontSize: 10,
                              color: AppColors.strongBuy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppPrimaryButton(
                      label: 'Upgrade Plan',
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.subscription),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: AppColors.accentBlue,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Personal Information',
                            style: AppTextStyles.title.copyWith(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InfoRow(label: 'Full name', value: user?.name ?? '—'),
                    const SizedBox(height: AppSpacing.sm),
                    _InfoRow(label: 'Email', value: user?.email ?? '—'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: AppColors.accentBlue,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Change Password',
                            style: AppTextStyles.title.copyWith(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Current Password',
                      hint: 'Enter your current password',
                      controller: _currentPasswordController,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _forgotCurrentPassword(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          'Forgot your current password?',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'New Password',
                      hint: 'Min. 6 characters',
                      controller: _newPasswordController,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Confirm New Password',
                      hint: 'Re-enter new password',
                      controller: _confirmPasswordController,
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: state.status == FormStatus.submitting
                                  ? null
                                  : () => context
                                        .read<ProfileCubit>()
                                        .updatePassword(
                                          currentPassword:
                                              _currentPasswordController.text,
                                          newPassword:
                                              _newPasswordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                        ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusMd,
                                  ),
                                ),
                              ),
                              child: state.status == FormStatus.submitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Update Password',
                                      style: AppTextStyles.button.copyWith(
                                        fontSize: 13.5,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Danger Zone',
                            style: AppTextStyles.title.copyWith(
                              fontSize: 15,
                              color: AppColors.danger,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Delete Account',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Permanently delete your account and all data. This cannot be undone.',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _confirmDelete(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: BorderSide(
                            color: AppColors.danger.withValues(alpha: 0.5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                        ),
                        child: const Text('Delete Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarSheet(BuildContext context, Uint8List? currentAvatar) {
    final profileCubit = context.read<ProfileCubit>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceAlt,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                leading: Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text('Take Photo', style: AppTextStyles.body),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  profileCubit.pickAvatar(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.textPrimary,
                ),
                title: Text('Choose from Gallery', style: AppTextStyles.body),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  profileCubit.pickAvatar(ImageSource.gallery);
                },
              ),
              if (currentAvatar != null)
                ListTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.danger,
                  ),
                  title: Text(
                    'Remove Photo',
                    style: AppTextStyles.body.copyWith(color: AppColors.danger),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    profileCubit.removeAvatar();
                  },
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  /// Forgetting your *current* password (as opposed to just wanting to
  /// change it) means change-password's "prove you know the old one" check
  /// can't be satisfied — so this signs out to the Login screen's existing
  /// "Forgot password?" reset flow instead of duplicating it here.
  Future<void> _forgotCurrentPassword(BuildContext context) async {
    final confirmed = await AppFeedback.showConfirmDialog(
      context,
      title: 'Forgot your password?',
      message:
          "You'll be signed out so you can reset it from the login screen.",
      confirmLabel: 'Sign Out',
    );
    if (!context.mounted || !confirmed) return;
    context.read<AuthCubit>().signOut();
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppFeedback.showConfirmDialog(
      context,
      title: 'Delete account?',
      message:
          'This permanently deletes your account and all data. This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!context.mounted || !confirmed) return;
    AppFeedback.showSnackBar(
      context,
      'Account deletion isn\'t available in this preview build.',
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12.5)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
