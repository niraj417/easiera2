import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primaryNavy = Color(0xFF0F1E35);
  static const Color primaryBlue = Color(0xFF1A5FB4);
  static const Color goldAccent = Color(0xFFF5B800);

  // Surface
  static const Color surfaceBackground = Color(0xFFF5F7FA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Status
  static const Color statusGreen = Color(0xFF22C55E);
  static const Color statusAmber = Color(0xFFF59E0B);
  static const Color statusRed = Color(0xFFEF4444);
  static const Color verifiedTeal = Color(0xFF0D9488);
  static const Color neutralGrey = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F1E35), Color(0xFF1A5FB4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5B800), Color(0xFFFF8C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text
  static const Color textPrimary = Color(0xFF0F1E35);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Score grade colors
  static const Color gradeAAA = Color(0xFF22C55E);
  static const Color gradeAA = Color(0xFF84CC16);
  static const Color gradeA = Color(0xFF3B82F6);
  static const Color gradeB = Color(0xFFF59E0B);
  static const Color gradeC = Color(0xFFEF4444);

  // Background variants
  static const Color lightBlue = Color(0xFFEFF6FF);
  static const Color lightGreen = Color(0xFFF0FDF4);
  static const Color lightAmber = Color(0xFFFFFBEB);
  static const Color lightRed = Color(0xFFFEF2F2);
  static const Color lightTeal = Color(0xFFF0FDFA);
  static const Color lightGold = Color(0xFFFFFDE7);
}
