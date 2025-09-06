import 'package:flutter/material.dart';
import 'dart:math';

class UserProfile {
  final String id;
  final String username;
  int experiencePoints;
  int currentLevel;
  int totalCompletedGoals;
  int totalDaysCompleted;
  int consecutiveDays;
  int maxConsecutiveDays;
  DateTime lastActivityDate;
  DateTime createdAt;
  UserProfile({
    required this.id,
    required this.username,
    this.experiencePoints = 0,
    this.currentLevel = 1,
    this.totalCompletedGoals = 0,
    this.totalDaysCompleted = 0,
    this.consecutiveDays = 0,
    this.maxConsecutiveDays = 0,
    required this.lastActivityDate,
    required this.createdAt,
  }) {}

  // ============ NOUVEAU SYSTÈME XP ============

  // Calculer l'XP requis pour un niveau donné selon la nouvelle progression
  static int getXpRequiredForLevel(int level) {
    if (level <= 1) return 0;

    // Table de progression manuelle pour plus de contrôle
    final xpTable = {
      2: 10, // Niveau 1 → 2
      3: 20, // Niveau 2 → 3
      4: 30, // Niveau 3 → 4
      5: 50, // Niveau 4 → 5
      6: 70, // Niveau 5 → 6
      7: 110, // Niveau 6 → 7
      8: 170, // Niveau 7 → 8
      9: 250, // Niveau 8 → 9
      10: 380, // Niveau 9 → 10
      11: 570, // Niveau 10 → 11
    };

    // Pour les niveaux au-delà de 11, utiliser la formule exponentielle
    if (xpTable.containsKey(level)) {
      return xpTable[level]!;
    } else {
      // Formule pour niveaux élevés: base 570 * 1.5^(level-11)
      final baseXp = 570 * pow(1.5, level - 11);
      return (baseXp / 10).ceil() * 10;
    }
  }

  // Calculer l'XP total requis pour atteindre un niveau
  static int getTotalXpForLevel(int level) {
    int totalXp = 0;
    for (int i = 2; i <= level; i++) {
      totalXp += getXpRequiredForLevel(i);
    }
    return totalXp;
  }

  // Calculer le niveau basé sur les points d'expérience
  void calculateLevel() {
    int newLevel = 1;
    int totalXpNeeded = 0;

    while (totalXpNeeded <= experiencePoints) {
      newLevel++;
      totalXpNeeded += getXpRequiredForLevel(newLevel);
    }

    final previousLevel = currentLevel;
    currentLevel = newLevel - 1; // Revenir au dernier niveau valide

    // Vérifier si on a gagné un niveau
    // if (currentLevel > previousLevel) {
    //   _onLevelUp(previousLevel, currentLevel);
    // }
  }

  // Gérer le passage de niveau
  // void _onLevelUp(int oldLevel, int newLevel) {
  //   // _checkSpecialBadges();
  // }

  // Ajouter de l'XP et calculer les gains de niveau
  LevelUpResult addExperience(int xp, {bool isConsistencyBonus = false}) {
    final oldLevel = currentLevel;
    final oldXp = experiencePoints;

    // Ajouter l'XP (avec bonus de consistance si applicable)
    final actualXp = isConsistencyBonus ? (xp * 1.2).round() : xp;
    experiencePoints += actualXp;

    // Recalculer le niveau
    calculateLevel();

    return LevelUpResult(
      oldLevel: oldLevel,
      newLevel: currentLevel,
      xpGained: actualXp,
      oldXp: oldXp,
      newXp: experiencePoints,
      hasLeveledUp: currentLevel > oldLevel,
    );
  }

  // Calculer l'XP d'un objectif selon sa durée et difficulté
  static int calculateGoalXp(int targetDays, {bool completedEarly = false}) {
    int baseXp;

    if (targetDays <= 7) {
      baseXp = 10 + ((targetDays - 1) * 5 / 6).round();
    } else if (targetDays <= 30) {
      baseXp = 30 + ((targetDays - 8) * 20 / 22).round();
    } else {
      baseXp = 80 + ((min(targetDays, 90) - 31) * 70 / 59).round();
    }

    return baseXp;
  }

  double get xpProgressToNextLevel {
    final currentLevelTotalXp = getTotalXpForLevel(currentLevel);
    final nextLevelTotalXp = getTotalXpForLevel(currentLevel + 1);
    final xpInCurrentLevel = experiencePoints - currentLevelTotalXp;
    final xpNeededForNextLevel = nextLevelTotalXp - currentLevelTotalXp;

    return (xpInCurrentLevel / xpNeededForNextLevel).clamp(0.0, 1.0);
  }

  // XP nécessaire pour le prochain niveau
  int get xpNeededForNextLevel {
    final nextLevelTotalXp = getTotalXpForLevel(currentLevel + 1);
    return nextLevelTotalXp - experiencePoints;
  }

  // XP dans le niveau actuel
  int get xpInCurrentLevel {
    final currentLevelTotalXp = getTotalXpForLevel(currentLevel);
    return experiencePoints - currentLevelTotalXp;
  }

  // XP total requis pour le niveau suivant
  int get xpRequiredForCurrentLevel {
    return getXpRequiredForLevel(currentLevel + 1);
  }

  // Obtenir le nom du niveau selon le nouveau système
  String get levelName {
    if (currentLevel >= 45) return 'Transcendent';
    if (currentLevel >= 40) return 'Legend';
    if (currentLevel >= 35) return 'Elite';
    if (currentLevel >= 30) return 'Champion';
    if (currentLevel >= 25) return 'Master';
    if (currentLevel >= 20) return 'Expert';
    if (currentLevel >= 15) return 'Determined';
    if (currentLevel >= 10) return 'Persevering';
    if (currentLevel >= 5) return 'Apprentice';
    return 'Beginner';
  }

  // Obtenir la couleur du niveau
  Color get levelColor {
    if (currentLevel >= 45) return Colors.deepPurple[800]!;
    if (currentLevel >= 40) return Colors.deepPurple[600]!;
    if (currentLevel >= 35) return Colors.indigo[600]!;
    if (currentLevel >= 30) return Colors.amber[600]!;
    if (currentLevel >= 25) return Colors.red[600]!;
    if (currentLevel >= 20) return Colors.purple[600]!;
    if (currentLevel >= 15) return Colors.orange[600]!;
    if (currentLevel >= 10) return Colors.green[600]!;
    if (currentLevel >= 5) return Colors.blue[600]!;
    return Colors.grey[600]!;
  }

  // Obtenir la progression vers le prochain niveau (ancien système, maintenu)

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      // Nouveau système XP
      'experiencePoints': experiencePoints,
      'currentLevel': currentLevel,
      'totalCompletedGoals': totalCompletedGoals,
      // Ancien système (maintenu)
      'totalDaysCompleted': totalDaysCompleted,
      'consecutiveDays': consecutiveDays,
      'maxConsecutiveDays': maxConsecutiveDays,
      'lastActivityDate': lastActivityDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      // Nouveau système XP (avec migration depuis l'ancien)
      experiencePoints: json['experiencePoints'] ?? (json['auraPoints'] ?? 0),
      currentLevel: json['currentLevel'] ?? (json['auraLevel'] ?? 1),
      totalCompletedGoals: json['totalCompletedGoals'] ?? 0,
      // Ancien système (maintenu)
      totalDaysCompleted: json['totalDaysCompleted'] ?? 0,
      consecutiveDays: json['consecutiveDays'] ?? 0,
      maxConsecutiveDays: json['maxConsecutiveDays'] ?? 0,
      lastActivityDate: DateTime.fromMillisecondsSinceEpoch(
        json['lastActivityDate'],
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  UserProfile copyWith({
    String? id,
    String? username,
    // Nouveau système XP
    int? experiencePoints,
    int? currentLevel,
    int? totalCompletedGoals,
    // Ancien système
    int? auraPoints,
    int? auraLevel,
    int? totalDaysCompleted,
    int? consecutiveDays,
    int? maxConsecutiveDays,
    DateTime? lastActivityDate,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      // Nouveau système XP
      experiencePoints: experiencePoints ?? this.experiencePoints,
      currentLevel: currentLevel ?? this.currentLevel,
      totalCompletedGoals: totalCompletedGoals ?? this.totalCompletedGoals,
      // Ancien système
      totalDaysCompleted: totalDaysCompleted ?? this.totalDaysCompleted,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Classe pour les résultats de gain de niveau
class LevelUpResult {
  final int oldLevel;
  final int newLevel;
  final int xpGained;
  final int oldXp;
  final int newXp;
  final bool hasLeveledUp;

  LevelUpResult({
    required this.oldLevel,
    required this.newLevel,
    required this.xpGained,
    required this.oldXp,
    required this.newXp,
    required this.hasLeveledUp,
  });
}
