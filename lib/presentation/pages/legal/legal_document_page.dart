import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/legal/legal_document.dart';
import '../../widgets/common/theme_toggle_button.dart';
import '../../widgets/legal/legal_section_card.dart';

/// Renders any [LegalDocument] — Disclaimer, Terms, Privacy Policy. The
/// documents differ only in their content, so they share this one screen
/// instead of each getting a near-identical widget tree.
class LegalDocumentPage extends StatelessWidget {
  const LegalDocumentPage({super.key, required this.document});

  final LegalDocument document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        title: Text(
          document.title,
          style: AppTextStyles.headline.copyWith(fontSize: 20),
        ),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Text(
              document.subtitle,
              style: AppTextStyles.title.copyWith(fontSize: 18, height: 1.35),
            ),
            if (document.effectiveDate.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Effective ${document.effectiveDate}',
                    style: AppTextStyles.badge.copyWith(
                      fontSize: 10.5,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < document.sections.length; i++) ...[
              if (i != 0) const SizedBox(height: AppSpacing.md),
              LegalSectionCard(section: document.sections[i]),
            ],
            if (document.footer != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                document.footer!,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(fontSize: 11.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
