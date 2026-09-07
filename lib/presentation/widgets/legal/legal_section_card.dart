import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/legal/legal_document.dart';

/// One clause of a [LegalDocument] — numbered badge, heading, then the
/// section's paragraphs and lists. Shared by every policy screen so
/// Disclaimer/Terms/Privacy read identically.
class LegalSectionCard extends StatelessWidget {
  const LegalSectionCard({super.key, required this.section});

  final LegalSection section;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.heading.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (section.number != null) ...[
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(
                      '${section.number}',
                      style: AppTextStyles.badge.copyWith(
                        fontSize: 11,
                        color: AppColors.accentBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      section.heading,
                      style: AppTextStyles.title.copyWith(fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          for (var i = 0; i < section.blocks.length; i++) ...[
            if (i != 0) const SizedBox(height: AppSpacing.sm),
            _LegalBlockView(block: section.blocks[i]),
          ],
        ],
      ),
    );
  }
}

class _LegalBlockView extends StatelessWidget {
  const _LegalBlockView({required this.block});

  final LegalBlock block;

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case LegalBlockType.paragraph:
        return Text(
          block.text,
          style: AppTextStyles.body.copyWith(fontSize: 13.5, height: 1.55),
        );
      case LegalBlockType.bullets:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in block.items)
              _ListItem(marker: '\u2022', text: item),
          ],
        );
      case LegalBlockType.numbered:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < block.items.length; i++)
              _ListItem(marker: '${i + 1}.', text: block.items[i]),
          ],
        );
    }
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required this.marker, required this.text});

  final String marker;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              marker,
              style: AppTextStyles.body.copyWith(
                fontSize: 13.5,
                height: 1.55,
                color: AppColors.accentBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(fontSize: 13.5, height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}
