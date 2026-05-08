import 'package:flutter/material.dart';

class AppColors {
  // ── Primary: Logistics Navy family ──────────────────────────────────────
  static const primary = Color(0xFF001142);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF00236F);
  static const onPrimaryContainer = Color(0xFF778EDE);

  // ── Secondary: Command Blue family ──────────────────────────────────────
  static const secondary = Color(0xFF4059AA);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFF8FA7FE);
  static const onSecondaryContainer = Color(0xFF1D3989);

  // ── Tertiary: Safety Orange accent ──────────────────────────────────────
  static const safetyOrange = Color(0xFFFD761A);

  // ── Surfaces ─────────────────────────────────────────────────────────────
  static const surface = Color(0xFFFAF8FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF4F3FA);
  static const surfaceContainer = Color(0xFFEFEDF4);

  // ── On-surface text ──────────────────────────────────────────────────────
  static const onSurface = Color(0xFF1A1B20);
  static const onSurfaceVariant = Color(0xFF444651);

  // ── Borders / Dividers ───────────────────────────────────────────────────
  static const outline = Color(0xFF757682);
  static const outlineVariant = Color(0xFFC5C5D3);
  static const softBorder = Color(0xFFE2E8F0);

  // ── Status ───────────────────────────────────────────────────────────────
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);

  // ── Chip / Highlight ─────────────────────────────────────────────────────
  static const paleSignalBlue = Color(0xFFDCE1FF);
  static const inversePrimary = Color(0xFFB5C4FF);

  // ── Legacy aliases (keeps existing code compiling) ───────────────────────
  static const logisticsNavy = primaryContainer;
  static const commandBlue = onSecondaryContainer;
  static const mistBackground = surface;
  static const cardWhite = surfaceContainerLowest;
  static const nearBlackInk = onSurface;
  static const mutedOperationalInk = onSurfaceVariant;
  static const criticalRed = error;
}
