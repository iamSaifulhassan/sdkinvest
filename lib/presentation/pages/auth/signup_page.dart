import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/auth/login_cubit.dart' show FormStatus;
import '../../../logic/auth/signup_cubit.dart';
import '../../widgets/auth/social_sign_in_button.dart';
import '../../widgets/common/app_brand_logo.dart';
import '../../widgets/common/app_feedback.dart';
import '../../widgets/common/app_primary_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Account-creation screen. Same cubit-owns-the-form / page-forwards-to-
/// AuthCubit split as [LoginPage] — see that file for the pattern.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatefulWidget {
  const _SignupView();

  @override
  State<_SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<_SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == FormStatus.success && state.user != null) {
              context.read<AuthCubit>().signedIn(state.user!);
            }
          },
          builder: (context, state) {
            final isSubmitting = state.status == FormStatus.submitting;
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                const Center(child: AppBrandLogo(size: 56)),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Create your account',
                  style: AppTextStyles.headline.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  'Start tracking SDK Scores across your whole portfolio.',
                  style: AppTextStyles.caption.copyWith(fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  label: 'Full name',
                  hint: 'Jane Doe',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Confirm password',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(context),
                ),
                const SizedBox(height: AppSpacing.md),
                _TermsCheckbox(
                  value: _acceptedTerms,
                  onChanged: (value) => setState(() => _acceptedTerms = value),
                ),
                if (state.status == FormStatus.failure &&
                    state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _ErrorBanner(message: state.errorMessage!),
                ],
                const SizedBox(height: AppSpacing.md),
                AppPrimaryButton(
                  label: 'Create Account',
                  isLoading: isSubmitting,
                  onPressed: () => _submit(context),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      child: Text('or', style: AppTextStyles.caption),
                    ),
                    Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SocialSignInButton(
                  provider: SocialProvider.google,
                  onPressed: () => AppFeedback.showSnackBar(
                    context,
                    'Google sign-in is coming in a later phase',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SocialSignInButton(
                  provider: SocialProvider.apple,
                  onPressed: () => AppFeedback.showSnackBar(
                    context,
                    'Apple sign-in is coming in a later phase',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () =>
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.login),
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: AppTextStyles.caption,
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    context.read<SignupCubit>().submit(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      acceptedTerms: _acceptedTerms,
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: AppColors.accentBlue,
              side: BorderSide(color: AppColors.border),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'I agree to the ',
                style: AppTextStyles.caption.copyWith(fontSize: 12),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.accent,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 16, color: AppColors.danger),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.danger,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
