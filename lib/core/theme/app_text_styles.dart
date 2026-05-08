import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Spline Sans — display & headline
  static TextStyle get display => GoogleFonts.splineSans(
        fontSize: 32,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.64,
        color: AppColors.primaryContainer,
      );

  static TextStyle get headline => GoogleFonts.splineSans(
        fontSize: 24,
        height: 1.33,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.24,
        color: AppColors.primaryContainer,
      );

  // Lexend — titles, body, labels
  static TextStyle get title => GoogleFonts.lexend(
        fontSize: 18,
        height: 1.33,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
      );

  static TextStyle get body => GoogleFonts.lexend(
        fontSize: 16,
        height: 1.5,
        color: AppColors.onSurface,
      );

  static TextStyle get bodyMuted => GoogleFonts.lexend(
        fontSize: 14,
        height: 1.43,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get label => GoogleFonts.lexend(
        fontSize: 12,
        height: 1.33,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
      );
}
