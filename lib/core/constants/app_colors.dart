import 'package:flutter/material.dart';

class AppColors {
  // Primary Action Blue
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Accent Red
  static const Color accent = Color(0xFFFF3B30);
  static const Color accentLight = Color(0xFFFF6B5B);
  static const Color accentDark = Color(0xFFE02B22);

  // Neo Brutalist Background & Surface
  static const Color background = Color(0xFFFDF6E2);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFFF3B30);

  // Success
  static const Color success = Color(0xFF16A34A);

  // Text Colors — high contrast
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textHint = Color(0xFF9CA3AF);

  // Border
  static const Color divider = Colors.black;
  static const Color border = Colors.black;

  // Neo Brutalist Palette
  static const Color neoYellow = Color(0xFFFFDE59);
  static const Color neoBlue = Color(0xFF38BDF8);
  static const Color neoPink = Color(0xFFFF6B9D);
  static const Color neoGreen = Color(0xFFA3E635);
  static const Color neoOrange = Color(0xFFFB923C);
  static const Color neoPurple = Color(0xFFA78BFA);

  static Color cardColor(int index) {
    const palette = [
      neoYellow,
      neoBlue,
      neoPink,
      neoGreen,
      neoOrange,
      neoPurple,
    ];
    return palette[index % palette.length];
  }
}
