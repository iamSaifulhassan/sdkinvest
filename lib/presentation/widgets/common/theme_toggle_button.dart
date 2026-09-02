import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../logic/theme/theme_cubit.dart';

/// Sun/moon icon that flips [ThemeCubit] between light and dark. Placed in
/// the same app-bar slot on every main screen (Home, Search, Watchlist,
/// Profile) so the toggle is reachable from anywhere.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<ThemeCubit>().state;
    final isDark = switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      icon: Icon(
        // The sun glyph reads as a golden/amber "light mode" affordance
        // (matching the reference design); the moon stays neutral.
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
        color: isDark ? AppColors.gold : AppColors.textPrimary,
      ),
      onPressed: () =>
          context.read<ThemeCubit>().toggle(currentlyDark: isDark),
    );
  }
}
