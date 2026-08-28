import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/demo_toggle/demo_toggle_cubit.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/app_content_card.dart';
import '../widgets/app_feedback.dart';
import '../widgets/app_loading_indicator.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_secondary_button.dart';
import '../widgets/app_text_field.dart';

/// Temporary page listing every widget from the shared library so they're
/// visually testable and clickable before real screens exist. Removed once
/// Phase 2 screens replace it as the app's home.
class WidgetShowcasePage extends StatefulWidget {
  const WidgetShowcasePage({super.key});

  @override
  State<WidgetShowcasePage> createState() => _WidgetShowcasePageState();
}

class _WidgetShowcasePageState extends State<WidgetShowcasePage> {
  bool _isPrimaryLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Widget Showcase'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const _SectionLabel('Buttons'),
            AppPrimaryButton(
              label: 'Primary Button',
              isLoading: _isPrimaryLoading,
              onPressed: () async {
                setState(() => _isPrimaryLoading = true);
                await Future<void>.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                setState(() => _isPrimaryLoading = false);
                AppFeedback.showSnackBar(context, 'Primary button pressed');
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppSecondaryButton(
              label: 'Secondary Button',
              onPressed: () => AppFeedback.showSnackBar(context, 'Secondary button pressed'),
            ),

            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('Text Input'),
            const AppTextField(label: 'Email', hint: 'you@example.com'),
            const SizedBox(height: AppSpacing.md),
            const AppTextField(label: 'Password', obscureText: true, errorText: 'Required field'),

            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('Content Card'),
            AppContentCard(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.placeholderDetail),
              child: Text('Tap to navigate to a second placeholder route', style: AppTextStyles.body),
            ),

            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('Loading States'),
            const Row(
              children: [
                AppLoadingIndicator(),
                SizedBox(width: AppSpacing.lg),
                Expanded(child: AppShimmerBox(height: 24)),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('Dialog'),
            AppSecondaryButton(
              label: 'Show Confirm Dialog',
              onPressed: () async {
                final confirmed = await AppFeedback.showConfirmDialog(
                  context,
                  title: 'Confirm action',
                  message: 'This is a dialog helper demo.',
                );
                if (!context.mounted) return;
                AppFeedback.showSnackBar(context, confirmed ? 'Confirmed' : 'Cancelled');
              },
            ),

            const SizedBox(height: AppSpacing.xl),
            const _SectionLabel('Bloc / Cubit Wiring'),
            AppContentCard(
              child: BlocBuilder<DemoToggleCubit, bool>(
                builder: (context, isOn) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Demo toggle is ${isOn ? 'ON' : 'OFF'}', style: AppTextStyles.body),
                      Switch(
                        value: isOn,
                        activeThumbColor: AppColors.primary,
                        onChanged: (_) => context.read<DemoToggleCubit>().toggle(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label, style: AppTextStyles.title),
    );
  }
}
