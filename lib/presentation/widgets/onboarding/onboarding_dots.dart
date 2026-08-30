import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Page-position indicator for the onboarding carousel — the active dot
/// stretches into a pill, matching common production onboarding patterns.
class OnboardingDots extends StatelessWidget {
  const OnboardingDots({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == activeIndex ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == activeIndex ? AppColors.accentBlue : AppColors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}
