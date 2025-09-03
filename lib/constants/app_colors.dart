import 'package:flutter/material.dart';

/// Comprehensive color system for HabitoX app with light and dark themes
class AppColors {
  // ===== LIGHT THEME COLORS =====

  // Light theme backgrounds
  static const Color lightBackgroundPrimary = Color(0xFFF8F9FA);
  static const Color lightBackgroundSecondary = Color(0xFFFFFFFF);
  static const Color lightSurfacePrimary = Color(0xFFFFFFFF);
  static const Color lightSurfaceSecondary = Color(0xFFF1F3F4);

  // Light theme text colors
  static const Color lightTextPrimary = Color(
    0xFF1F4843,
  ); // Dark green for primary text
  static const Color lightTextSecondary = Color(
    0xFF2A5A55,
  ); // Lighter green for secondary text
  static const Color lightTextMuted = Color(
    0xFF3A6A65,
  ); // Even lighter for muted text
  static const Color lightTextHeading = Color(
    0xFF1F4843,
  ); // Dark green for headings

  // Light theme borders and shadows
  static const Color lightBorderPrimary = Color(
    0xFF85B8CB,
  ); // Light blue border
  static const Color lightBorderSecondary = Color(0xFFE9ECEF);
  static const Color lightShadowColor = Color(0xFFE9ECEF);

  // ===== DARK THEME COLORS =====

  // Dark theme backgrounds (as specified)
  static const Color darkBackgroundPrimary = Color(
    0xFF0D0D0D,
  ); // Deep dark gray
  static const Color darkBackgroundSecondary = Color(
    0xFF121212,
  ); // Slightly lighter dark gray
  static const Color darkSurfacePrimary = Color(0xFF1E1E1E); // Surface color
  static const Color darkSurfaceSecondary = Color(
    0xFF2A2A2A,
  ); // Secondary surface

  // Dark theme text colors (as specified)
  static const Color darkTextPrimary = Color(
    0xFFE0E0E0,
  ); // Off-white for primary text
  static const Color darkTextSecondary = Color(
    0xFFA0A0A0,
  ); // Medium gray for secondary text
  static const Color darkTextMuted = Color(0xFF808080); // Muted gray
  static const Color darkTextHeading = Color(
    0xFFFFFFFF,
  ); // Pure white for headings

  // Dark theme borders and shadows
  static const Color darkBorderPrimary = Color(0xFF2A2A2A); // Subtle border
  static const Color darkBorderSecondary = Color(0xFF404040);
  static const Color darkShadowColor = Color(0xFF000000);

  // ===== ACCENT COLORS =====

  // Professional accent colors (as specified)
  static const Color accentPrimary = Color(0xFF2DD4BF); // Professional teal
  static const Color accentSecondary = Color(0xFF3A86FF); // Electric blue
  static const Color accentTertiary = Color(0xFF06B6D4); // Cyan variant

  // ===== LEGACY COLORS (for backward compatibility) =====
  static const Color primaryColor = Color(0xFF2DD4BF); // Updated to use teal
  static const Color lightColor = Color(0xFF85B8CB); // Light blue
  static const Color darkColor = Color(0xFF1F4843); // Dark green

  // ===== STATE COLORS =====
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // ===== NEUTRAL COLORS =====
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ===== BACKWARD COMPATIBILITY =====
  static const Color surfaceColor = lightSurfacePrimary;
  static const Color scaffoldBackgroundColor = lightBackgroundPrimary;
  static const Color textPrimary = lightTextPrimary;
  static const Color textSecondary = lightTextSecondary;
  static const Color textMuted = lightTextMuted;
  static const Color borderColor = lightBorderPrimary;
  static const Color borderColorLight = lightBorderSecondary;
  static const Color shadowColor = lightShadowColor;
  static const Color shadowColorLight = lightShadowColor;
}

/// Thème de couleurs pour les composants spécifiques
class ComponentColors {
  // Couleurs pour les cartes
  static const Color cardBackground = AppColors.white;
  static const Color cardBorder = AppColors.lightColor; // #85b8cb
  static const Color cardShadow = AppColors.darkColor; // #1f4843

  // Couleurs pour les boutons
  static const Color buttonPrimary = AppColors.primaryColor; // #a7c6a5
  static const Color buttonSecondary = AppColors.lightColor; // #85b8cb
  static const Color buttonText = AppColors.darkColor; // #1f4843

  // Couleurs pour les inputs
  static const Color inputBackground = AppColors.lightColor; // #85b8cb
  static const Color inputBorder = AppColors.lightColor; // #85b8cb
  static const Color inputFocusBorder = AppColors.primaryColor; // #a7c6a5

  // Couleurs pour les indicateurs de progression
  static const Color progressBackground = AppColors.lightColor; // #85b8cb
  static const Color progressFill = AppColors.primaryColor; // #a7c6a5

  // Couleurs pour les badges
  static const Color badgeBackground = AppColors.primaryColor; // #a7c6a5
  static const Color badgeText = AppColors.darkColor; // #1f4843

  // Couleurs pour les onglets
  static const Color tabBackground = AppColors.lightColor; // #85b8cb
  static const Color tabActive = AppColors.primaryColor; // #a7c6a5
  static const Color tabInactive = AppColors.lightColor; // #85b8cb
  static const Color tabText = AppColors.darkColor; // #1f4843
}

/// Couleurs pour les états et statuts
class StatusColors {
  static const Color active = AppColors.primaryColor; // #a7c6a5
  static const Color inactive = AppColors.textMuted; // #3a6a65
  static const Color completed = AppColors.successColor;
  static const Color pending = AppColors.warningColor;
  static const Color error = AppColors.errorColor;
  static const Color info = AppColors.infoColor;
}
