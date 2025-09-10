import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales
  static const Color darkColor = Color(0xFFA7C6A5);
  static const Color primaryColor = Color(0xFF1F4843);

  static const Color primaryLight = Color(0xFFB8D1B6);
  static const Color primaryDark = Color(0xFF8FB28D);

  // Background Card
  static const Color surfaceColor = Colors.white;
  static const Color surfaceColorDark = Color(0xFF1f222a);

  // Background
  static const Color scaffoldBackgroundColor = Color.fromRGBO(226, 239, 243, 1);
  static const Color scaffoldBackgroundColorDark = Color(0xFF181920);

  // Couleurs d'état
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Couleurs neutres
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Couleurs de texte - TOUT en vert foncé (#1f4843)
  static const Color textPrimary = darkColor; // #1f4843
  static const Color textSecondary = Color(
    0xFF2A5A55,
  ); // Version plus claire du vert foncé
  static const Color textMuted = Color(
    0xFF3A6A65,
  ); // Version encore plus claire

  static const Color borderColorLight = Color(0xFFE9ECEF);
  // Couleurs de bordure

  // Couleurs d'ombre
  static const Color shadowColor = darkColor; // #1f4843
  static const Color shadowColorLight = Color(0xFFE9ECEF);
}

/// Thème de couleurs pour les composants spécifiques
class ComponentColors {
  // Couleurs pour les cartes
  static const Color cardBackground = AppColors.white;
  static const Color cardShadow = AppColors.darkColor; // #1f4843

  // Couleurs pour les boutons
  static const Color buttonPrimary = AppColors.primaryColor; // #a7c6a5
  static const Color buttonText = AppColors.darkColor; // #1f4843

  // Couleurs pour les inputs
  static const Color inputFocusBorder = AppColors.primaryColor; // #a7c6a5

  static const Color progressFill = AppColors.primaryColor; // #a7c6a5

  // Couleurs pour les badges
  static const Color badgeBackground = AppColors.primaryColor; // #a7c6a5
  static const Color badgeText = AppColors.darkColor; // #1f4843

  // Couleurs pour les onglets
  static const Color tabActive = AppColors.primaryColor; // #a7c6a5
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
