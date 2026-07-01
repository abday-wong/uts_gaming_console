import 'package:flutter/material.dart';
import 'package:uts_gaming_console/core/constants/app_colors.dart';

/// Neubrutalism design tokens and helpers.
/// 
/// Usage:
/// ```dart
/// Container(
///   decoration: NeoTheme.neoDecoration(color: AppColors.neoYellow),
/// )
/// ```
class NeoTheme {
  NeoTheme._();

  // ── Borders ──
  static Border get border => Border.all(color: Colors.black, width: 2.5);
  static Border get borderThin => Border.all(color: Colors.black, width: 2);

  // ── Shadows (flat, no blur) ──
  static const BoxShadow shadow = BoxShadow(
    color: Colors.black,
    offset: Offset(4, 4),
    blurRadius: 0,
  );

  static const BoxShadow shadowSmall = BoxShadow(
    color: Colors.black,
    offset: Offset(3, 3),
    blurRadius: 0,
  );

  // ── Border Radius ──
  static BorderRadius get radius => BorderRadius.circular(10);
  static BorderRadius get radiusSmall => BorderRadius.circular(8);

  // ── Convenience BoxDecoration ──
  static BoxDecoration neoDecoration({
    Color color = Colors.white,
    bool small = false,
  }) {
    return BoxDecoration(
      color: color,
      border: border,
      borderRadius: radius,
      boxShadow: [small ? shadowSmall : shadow],
    );
  }

  /// Neo-style button (ElevatedButton.styleFrom)
  static ButtonStyle neoButtonStyle({
    Color backgroundColor = const Color(0xFF2563EB),
    Color foregroundColor = Colors.white,
    double vertical = 14,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 0,
      padding: EdgeInsets.symmetric(vertical: vertical),
      shape: RoundedRectangleBorder(
        borderRadius: radiusSmall,
        side: const BorderSide(color: Colors.black, width: 2.5),
      ),
    );
  }
}
