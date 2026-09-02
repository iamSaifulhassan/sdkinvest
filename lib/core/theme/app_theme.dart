import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  /// Builds the [ThemeData] for whichever mode [AppColors.isDark] currently
  /// reflects. Callers set [AppColors.isDark] first (see `main.dart`), so
  /// this always matches the getters every screen reads colors from.
  static ThemeData get current {
    final brightness = AppColors.isDark ? Brightness.dark : Brightness.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accent,
        onSecondary: Colors.white,
        error: AppColors.danger,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTextStyles.title,
        // Status bar icons/text need to contrast with whichever background
        // is currently showing: light icons on the dark-navy theme, dark
        // icons on the light theme.
        systemOverlayStyle: AppColors.isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      // Several screens stack 3-4 action icons (bell, theme toggle, profile
      // avatar, plus a screen-specific icon) next to a back button — the
      // default 48x48 Material tap target for each is too wide for that
      // combination on a phone-width AppBar and clips/overflows. Shrinking
      // every IconButton app-wide keeps them comfortably tappable without
      // hitting that.
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.all(6),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: AppTextStyles.headline,
        titleMedium: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTextStyles.body,
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(backgroundColor: AppColors.surfaceAlt),
    );
  }
}
