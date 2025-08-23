import 'package:flutter/material.dart';

/// Couleurs du design épuré global de l'application HabitoX
class AppColors {
  // Couleurs principales
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte

  // Couleurs dérivées pour la cohérence
  static const Color primaryLight = Color(0xFFB8D1B6); // Vert plus clair
  static const Color primaryDark = Color(0xFF8FB28D); // Vert plus foncé

  // Couleurs avec opacités pour les arrière-plans et bordures
  static const Color lightColorTransparent = Color(0x1A85B8CB);
  static const Color darkColorTransparent = Color(0x1A1F4843);

  // Couleurs d'état
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Couleurs neutres
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Méthodes utilitaires pour les opacités
  static Color primaryWithOpacity(double opacity) =>
      primaryColor.withOpacity(opacity);
  static Color lightWithOpacity(double opacity) =>
      lightColor.withOpacity(opacity);
  static Color darkWithOpacity(double opacity) =>
      darkColor.withOpacity(opacity);

  // Couleurs de surface
  static const Color surfaceColor = white;
  static const Color scaffoldBackgroundColor = Color(0xFFF8F9FA);

  // Couleurs de texte - TOUT en vert foncé (#1f4843)
  static const Color textPrimary = darkColor; // #1f4843
  static const Color textSecondary = Color(
    0xFF2A5A55,
  ); // Version plus claire du vert foncé
  static const Color textMuted = Color(
    0xFF3A6A65,
  ); // Version encore plus claire

  // Couleurs de bordure
  static const Color borderColor = lightColor; // #85b8cb
  static const Color borderColorLight = Color(0xFFE9ECEF);

  // Couleurs d'ombre
  static const Color shadowColor = darkColor; // #1f4843
  static const Color shadowColorLight = Color(0xFFE9ECEF);
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
