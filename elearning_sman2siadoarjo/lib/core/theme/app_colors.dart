import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF0062b3);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Secondary & Accent
  static const Color secondary = Color(0xFF4CAF50);
  static const Color tertiary = Color(0xFFFF9800);

  // Neutral
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  // Background
  static const Color background = Color(0xFFF5F7FA);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  // MaterialColor (buat primarySwatch)
  static const MaterialColor primarySwatch = MaterialColor(0xFF0062b3, {
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(0xFF0062b3),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });
}
