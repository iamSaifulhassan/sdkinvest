import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/app_primary_button.dart';

/// Second placeholder route used only to confirm navigation works end to end.
class PlaceholderDetailPage extends StatelessWidget {
  const PlaceholderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Placeholder Detail'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You navigated here from the widget showcase.', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.xl),
              AppPrimaryButton(
                label: 'Go Back',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
