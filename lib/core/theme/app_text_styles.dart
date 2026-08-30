import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale matching the SDK Investing mockups: a serif display
/// face reserved for the "SDK" wordmark and section headlines, Inter for
/// everything else (labels, body copy, and — with tabular figures — prices
/// and scores).
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get _serif => GoogleFonts.playfairDisplay();
  static TextStyle get _sans => GoogleFonts.inter();

  /// The "SDK" brand wordmark treatment.
  static TextStyle get wordmark => _serif.copyWith(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  /// Large serif numerals — portfolio value, hero figures.
  static TextStyle get displayFigure => _serif.copyWith(
    color: AppColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headline => _sans.copyWith(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get title => _sans.copyWith(
    color: AppColors.textSecondary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get body => _sans.copyWith(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get caption => _sans.copyWith(
    color: AppColors.textMuted,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get button => _sans.copyWith(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// Bold, tight-tracking uppercase label for status pills (STRONG BUY, TRIM…).
  static TextStyle get badge => _sans.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  /// Tabular-figure numerals for prices, scores, and percentages so columns align.
  static TextStyle get figure => _sans.copyWith(
    color: AppColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
