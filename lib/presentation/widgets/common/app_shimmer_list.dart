import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'app_loading_indicator.dart';

/// Skeleton list of shimmer rows shown while a screen's data cubit is loading.
class AppShimmerList extends StatelessWidget {
  const AppShimmerList({super.key, this.itemCount = 5, this.rowHeight = 68});

  final int itemCount;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == itemCount - 1 ? 0 : AppSpacing.sm,
          ),
          child: AppShimmerBox(
            height: rowHeight,
            borderRadius: AppSpacing.radiusMd,
          ),
        );
      }),
    );
  }
}
