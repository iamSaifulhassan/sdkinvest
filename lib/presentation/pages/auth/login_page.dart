import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../../logic/auth/login_cubit.dart';
import '../../widgets/auth/social_sign_in_button.dart';
import '../../widgets/common/app_feedback.dart';
import '../../widgets/common/app_primary_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Sign-in screen. Form validation/submission is owned by [LoginCubit];
/// this page's only extra job is forwarding a successful sign-in to the
/// app-level [AuthCubit] so [AuthGate] swaps to the main app shell.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LoginCubit(), child: const _LoginView());
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
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
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              children: [
                Row(
                  children: [
                    Text('SDK', style: AppTextStyles.wordmark),
                    const SizedBox(width: 6),
                    Text(
                      'Investing',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text('Welcome back', style: AppTextStyles.headline),
                const SizedBox(height: 4),
                Text(
                  'Log in to see your latest SDK Scores.',
                  style: AppTextStyles.caption.copyWith(fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.xl),
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
                  hint: 'Enter your password',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onSubmitted: (_) => _submit(context),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => AppFeedback.showSnackBar(
                      context,
                      'Password reset is coming in a later phase',
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (state.status == FormStatus.failure &&
                    state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _ErrorBanner(message: state.errorMessage!),
                ],
                const SizedBox(height: AppSpacing.md),
                AppPrimaryButton(
                  label: 'Log In',
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
                                  .pushReplacementNamed(AppRoutes.signup),
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.caption,
                        children: [
                          TextSpan(
                            text: 'Sign Up',
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
    context.read<LoginCubit>().submit(
      email: _emailController.text,
      password: _passwordController.text,
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
