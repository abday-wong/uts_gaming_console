import 'package:flutter/material.dart';
import 'package:uts_gaming_console/core/constants/app_colors.dart';

class NeoTheme {
  NeoTheme._();

  static Border get border => Border.all(color: Colors.black, width: 2.5);
  static Border get borderThin => Border.all(color: Colors.black, width: 2);

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

  static BorderRadius get radius => BorderRadius.circular(10);
  static BorderRadius get radiusSmall => BorderRadius.circular(8);

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
