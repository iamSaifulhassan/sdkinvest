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

/// Profile screen — account summary, subscription status, editable personal
/// info, change-password form, support/legal links, and account deletion.
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
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Seeded once from the session rather than watched, so typing isn't
    // clobbered by an unrelated AuthCubit rebuild. Saving pushes the edits
    // back to AuthCubit, which keeps the two in sync from then on.
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
          listenWhen: (previous, current) =>
              previous.passwordStatus != current.passwordStatus ||
              previous.profileStatus != current.profileStatus,
          listener: (context, state) {
            if (state.profileStatus == FormStatus.success &&
                state.savedUser != null) {
              context.read<AuthCubit>().profileUpdated(state.savedUser!);
              AppFeedback.showSnackBar(context, 'Profile updated.');
            } else if (state.profileStatus == FormStatus.failure &&
                state.profileError != null) {
              AppFeedback.showSnackBar(context, state.profileError!);
            }

            if (state.passwordStatus == FormStatus.success) {
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
              AppFeedback.showSnackBar(context, 'Password updated.');
            } else if (state.passwordStatus == FormStatus.failure &&
                state.passwordError != null) {
              AppFeedback.showSnackBar(context, state.passwordError!);
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
              Text(
                'My Profile',
                style: AppTextStyles.headline.copyWith(fontSize: 26),
              ),
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
                      onPressed: () =>
                          Navigator.of(context)
                              .pushNamed(AppRoutes.subscription),
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
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Your full name',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Email Address',
                      hint: 'you@example.com',
                      controller: _emailController,
                      prefixIcon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    BlocBuilder<ProfileCubit, ProfileState>(
                      buildWhen: (previous, current) =>
                          previous.profileStatus != current.profileStatus,
                      builder: (context, state) {
                        return _SubmitButton(
                          label: 'Save Changes',
                          busy: state.profileStatus == FormStatus.submitting,
                          onPressed: () =>
                              context.read<ProfileCubit>().saveProfile(
                                name: _nameController.text,
                                email: _emailController.text,
                              ),
                        );
                      },
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
                      buildWhen: (previous, current) =>
                          previous.passwordStatus != current.passwordStatus,
                      builder: (context, state) {
                        return _SubmitButton(
                          label: 'Update Password',
                          busy: state.passwordStatus == FormStatus.submitting,
                          onPressed: () =>
                              context.read<ProfileCubit>().updatePassword(
                                currentPassword:
                                    _currentPasswordController.text,
                                newPassword: _newPasswordController.text,
                                confirmPassword:
                                    _confirmPasswordController.text,
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const _SupportAndLegalCard(),
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
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
      message: 'This permanently deletes your account and all data. This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!context.mounted || !confirmed) return;
    AppFeedback.showSnackBar(
      context,
      'Account deletion isn\'t available in this preview build.',
    );
  }
}

/// Right-aligned accent submit button with an inline spinner — shared by
/// this screen's two forms so they stay visually identical.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: busy ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentBlue,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
          child: busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.button.copyWith(fontSize: 13.5),
                ),
        ),
      ),
    );
  }
}

/// Links out to the policy and help screens — the app-side equivalent of
/// the website footer's Explore/Legal columns.
class _SupportAndLegalCard extends StatelessWidget {
  const _SupportAndLegalCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                size: 18,
                color: AppColors.accentBlue,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Support & Legal',
                  style: AppTextStyles.title.copyWith(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _LinkTile(
            icon: Icons.support_agent_rounded,
            label: 'Contact & Support',
            route: AppRoutes.contactSupport,
          ),
          _LinkTile(
            icon: Icons.quiz_outlined,
            label: 'FAQ',
            route: AppRoutes.faq,
          ),
          _LinkTile(
            icon: Icons.gavel_rounded,
            label: 'Disclaimer',
            route: AppRoutes.disclaimer,
          ),
          _LinkTile(
            icon: Icons.description_outlined,
            label: 'Terms & Conditions',
            route: AppRoutes.terms,
          ),
          _LinkTile(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            route: AppRoutes.privacyPolicy,
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    // The enclosing _SectionCard paints its background with a BoxDecoration,
    // which would hide a ripple drawn on the Scaffold's Material below it.
    // A transparent Material here sits above that background instead.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(icon, size: 17, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.5,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
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
