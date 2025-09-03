import 'package:flutter/material.dart';
import 'dart:math';

class UserProfile {
  final String id;
  final String username;
  // Nouveau système XP (garde l'ancien pour migration)
  int experiencePoints;
  int currentLevel;
  int totalCompletedGoals;
  // Ancien système (maintenu pour rétrocompatibilité)
  int auraPoints;
  int auraLevel;
  int totalDaysCompleted;
  int consecutiveDays;
  int maxConsecutiveDays;
  DateTime lastActivityDate;
  DateTime createdAt;
  List<AuraBadge> unlockedBadges;
  List<SpecialBadge> specialBadges;

  UserProfile({
    required this.id,
    required this.username,
    // Nouveau système XP
    this.experiencePoints = 0,
    this.currentLevel = 1,
    this.totalCompletedGoals = 0,
    // Ancien système (maintenu pour migration)
    this.auraPoints = 0,
    this.auraLevel = 1,
    this.totalDaysCompleted = 0,
    this.consecutiveDays = 0,
    this.maxConsecutiveDays = 0,
    required this.lastActivityDate,
    required this.createdAt,
    List<AuraBadge>? unlockedBadges,
    List<SpecialBadge>? specialBadges,
  }) : unlockedBadges = unlockedBadges ?? [],
       specialBadges = specialBadges ?? [] {
    // S'assurer que les nouveaux utilisateurs (niveau 1) ont le badge par défaut
    if (currentLevel == 1 && this.unlockedBadges.isEmpty) {
      this.unlockedBadges.add(AuraBadge.createForLevel(1));
    }
  }

  // Calculer le niveau d'aura basé sur les points
  void calculateAuraLevel() {
    // Formule: niveau = 1 + sqrt(points / 100)
    auraLevel = 1 + sqrt(auraPoints / 100).floor();
  }

  // Ajouter de l'aura pour un jour complété
  void addAuraForDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(
      lastActivityDate.year,
      lastActivityDate.month,
      lastActivityDate.day,
    );

    if (today.difference(lastDay).inDays == 1) {
      // Jour consécutif
      consecutiveDays++;
      maxConsecutiveDays = max(maxConsecutiveDays, consecutiveDays);

      // Bonus d'aura pour les séries
      int bonus = 0;
      if (consecutiveDays >= 7) {
        bonus = 50; // 7 jours = +50
      } else if (consecutiveDays >= 3) {
        bonus = 20; // 3 jours = +20
      }

      auraPoints += 100 + bonus; // Base 100 + bonus série
    } else if (today.difference(lastDay).inDays > 1) {
      // Jour manqué - perte exponentielle d'aura
      int daysMissed = today.difference(lastDay).inDays - 1;
      int auraLost = _calculateExponentialAuraLoss(daysMissed);
      auraPoints = max(0, auraPoints - auraLost);

      // Reset de la série
      consecutiveDays = 1;
    } else {
      // Même jour - pas de changement
      return;
    }

    totalDaysCompleted++;
    lastActivityDate = now;
    calculateAuraLevel();
    _checkForNewBadges();
  }

  // Calculer la perte d'aura exponentielle
  int _calculateExponentialAuraLoss(int daysMissed) {
    // Formule: perte = 50 * (1.5 ^ jours_manqués)
    return (50 * pow(1.5, daysMissed)).round();
  }

  // Vérifier les nouveaux badges
  void _checkForNewBadges() {
    final newLevel = auraLevel;

    // Badge de niveau 1 (déjà géré dans le constructeur)
    // Badge de niveau 2 (premier objectif terminé)
    if (newLevel >= 2) {
      final existingLevel2Badge = unlockedBadges
          .where((badge) => badge.level == 2)
          .firstOrNull;
      if (existingLevel2Badge == null) {
        unlockedBadges.add(AuraBadge.createForLevel(2));
      }
    }

    // Badges tous les 5 niveaux (comme avant)
    final badgeLevel =
        ((newLevel - 1) ~/ 5) * 5 + 5; // Badge tous les 5 niveaux

    if (badgeLevel > 0 && badgeLevel <= newLevel) {
      final existingBadge = unlockedBadges
          .where((badge) => badge.level == badgeLevel)
          .firstOrNull;
      if (existingBadge == null) {
        unlockedBadges.add(AuraBadge.createForLevel(badgeLevel));
      }
    }
  }

  // Méthode pour augmenter le niveau après completion d'un objectif (ancien système)
  void onGoalCompleted() {
    // Pour le premier objectif terminé, passer automatiquement au niveau 2
    if (auraLevel == 1) {
      auraLevel = 2;
      auraPoints = 100; // Points minimum pour le niveau 2
      _checkForNewBadges();
    }
  }

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
    if (currentLevel > previousLevel) {
      _onLevelUp(previousLevel, currentLevel);
    }
  }

  // Gérer le passage de niveau
  void _onLevelUp(int oldLevel, int newLevel) {
    // Débloquer un badge seulement aux niveaux clés
    if (_shouldUnlockBadgeAtLevel(newLevel)) {
      final existingBadge = unlockedBadges
          .where((badge) => badge.level == newLevel)
          .firstOrNull;
      if (existingBadge == null) {
        unlockedBadges.add(AuraBadge.createForLevel(newLevel));
      }
    }

    // Vérifier les badges spéciaux
    _checkSpecialBadges();
  }

  // Vérifier si un badge doit être débloqué à ce niveau
  bool _shouldUnlockBadgeAtLevel(int level) {
    // Badges seulement aux niveaux: 1, 4, 9, puis tous les 10 niveaux
    if (level == 1 || level == 4 || level == 9) return true;
    if (level >= 10 && (level - 9) % 10 == 0) return true; // 19, 29, 39, etc.
    return false;
  }

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
      // Objectif court: 5-15 XP
      baseXp = 5 + ((targetDays - 1) * 10 / 6).round();
    } else if (targetDays <= 30) {
      // Objectif moyen: 20-50 XP
      baseXp = 20 + ((targetDays - 8) * 30 / 22).round();
    } else {
      // Objectif long: 60-150 XP
      baseXp = 60 + ((min(targetDays, 90) - 31) * 90 / 59).round();
    }

    // Bonus de consistance (+20% si terminé avant deadline)
    if (completedEarly) {
      baseXp = (baseXp * 1.2).round();
    }

    return baseXp;
  }

  // Nouveau getter: progression vers le prochain niveau (système XP)
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
    if (currentLevel >= 49) return 'Transcendant';
    if (currentLevel >= 39) return 'Légende';
    if (currentLevel >= 29) return 'Champion';
    if (currentLevel >= 19) return 'Maître';
    if (currentLevel >= 9) return 'Elite';
    if (currentLevel >= 4) return 'Déterminé';
    return 'Débutant';
  }

  // Obtenir la couleur du niveau
  Color get levelColor {
    if (currentLevel >= 49) return Colors.deepPurple[800]!;
    if (currentLevel >= 39) return Colors.deepPurple[600]!;
    if (currentLevel >= 29) return Colors.amber[600]!;
    if (currentLevel >= 19) return Colors.red[600]!;
    if (currentLevel >= 9) return Colors.purple[600]!;
    if (currentLevel >= 4) return Colors.orange[600]!;
    return Colors.grey[600]!;
  }

  // Vérifier les badges spéciaux
  void _checkSpecialBadges() {
    // Badge "Éclair" : 3 objectifs complétés en une semaine
    // Badge "Marathon" : Objectif de 30+ jours terminé
    // Badge "Perfectionniste" : 5 objectifs terminés avant la deadline
    // Badge "Régulier" : 7 jours consécutifs d'activité

    // Ces vérifications seront implémentées selon les données disponibles
    // Pour l'instant, on laisse cette méthode vide
  }

  // Obtenir la progression vers le prochain niveau (ancien système, maintenu)
  double get progressToNextLevel {
    final currentLevelPoints = pow((auraLevel - 1) * 100, 2).toInt();
    final nextLevelPoints = pow(auraLevel * 100, 2).toInt();
    final pointsInCurrentLevel = auraPoints - currentLevelPoints;
    final pointsNeededForLevel = nextLevelPoints - currentLevelPoints;

    return (pointsInCurrentLevel / pointsNeededForLevel).clamp(0.0, 1.0);
  }

  // Obtenir le nom du niveau d'aura
  String get auraLevelName {
    if (auraLevel >= 50) return 'Légende Astrale';
    if (auraLevel >= 40) return 'Maître Éthéré';
    if (auraLevel >= 30) return 'Gardien Céleste';
    if (auraLevel >= 20) return 'Adepte Lumineux';
    if (auraLevel >= 10) return 'Initié Radieux';
    if (auraLevel >= 5) return 'Apprenti Brillant';
    return 'Novice Aura';
  }

  // Obtenir la couleur de l'aura basée sur le niveau
  Color get auraColor {
    if (auraLevel >= 50) return Colors.purple;
    if (auraLevel >= 40) return Colors.deepPurple;
    if (auraLevel >= 30) return Colors.indigo;
    if (auraLevel >= 20) return Colors.blue;
    if (auraLevel >= 10) return Colors.teal;
    if (auraLevel >= 5) return Colors.green;
    return Colors.grey;
  }

  // Obtenir l'emoji de l'aura basé sur le niveau
  String get auraEmoji {
    if (auraLevel >= 50) return '🌟';
    if (auraLevel >= 40) return '✨';
    if (auraLevel >= 30) return '💫';
    if (auraLevel >= 20) return '⭐';
    if (auraLevel >= 10) return '⚡';
    if (auraLevel >= 5) return '🔮';
    return '💎';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      // Nouveau système XP
      'experiencePoints': experiencePoints,
      'currentLevel': currentLevel,
      'totalCompletedGoals': totalCompletedGoals,
      // Ancien système (maintenu)
      'auraPoints': auraPoints,
      'auraLevel': auraLevel,
      'totalDaysCompleted': totalDaysCompleted,
      'consecutiveDays': consecutiveDays,
      'maxConsecutiveDays': maxConsecutiveDays,
      'lastActivityDate': lastActivityDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'unlockedBadges': unlockedBadges.map((badge) => badge.toJson()).toList(),
      'specialBadges': specialBadges.map((badge) => badge.toJson()).toList(),
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
      auraPoints: json['auraPoints'] ?? 0,
      auraLevel: json['auraLevel'] ?? 1,
      totalDaysCompleted: json['totalDaysCompleted'] ?? 0,
      consecutiveDays: json['consecutiveDays'] ?? 0,
      maxConsecutiveDays: json['maxConsecutiveDays'] ?? 0,
      lastActivityDate: DateTime.fromMillisecondsSinceEpoch(
        json['lastActivityDate'],
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      unlockedBadges:
          (json['unlockedBadges'] as List<dynamic>?)
              ?.map((badge) => AuraBadge.fromJson(badge))
              .toList() ??
          [],
      specialBadges:
          (json['specialBadges'] as List<dynamic>?)
              ?.map((badge) => SpecialBadge.fromJson(badge))
              .toList() ??
          [],
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
    List<AuraBadge>? unlockedBadges,
    List<SpecialBadge>? specialBadges,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      // Nouveau système XP
      experiencePoints: experiencePoints ?? this.experiencePoints,
      currentLevel: currentLevel ?? this.currentLevel,
      totalCompletedGoals: totalCompletedGoals ?? this.totalCompletedGoals,
      // Ancien système
      auraPoints: auraPoints ?? this.auraPoints,
      auraLevel: auraLevel ?? this.auraLevel,
      totalDaysCompleted: totalDaysCompleted ?? this.totalDaysCompleted,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      createdAt: createdAt ?? this.createdAt,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
      specialBadges: specialBadges ?? this.specialBadges,
    );
  }
}

class AuraBadge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int level;
  final Color color;
  final DateTime unlockedAt;

  AuraBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.level,
    required this.color,
    required this.unlockedAt,
  });

  static AuraBadge createForLevel(int level) {
    final badgeData = _getBadgeDataForLevel(level);
    return AuraBadge(
      id: 'aura_badge_$level',
      name: badgeData['name'],
      description: badgeData['description'],
      emoji: badgeData['emoji'],
      level: level,
      color: badgeData['color'],
      unlockedAt: DateTime.now(),
    );
  }

  static Map<String, dynamic> _getBadgeDataForLevel(int level) {
    switch (level) {
      case 1:
        return {
          'name': 'Débutant',
          'description': 'Bienvenue dans votre parcours HabitoX !',
          'emoji': '💎',
          'color': Colors.grey[600],
        };
      case 4:
        return {
          'name': 'Déterminé',
          'description': 'Votre détermination commence à porter ses fruits !',
          'emoji': '⚡',
          'color': Colors.orange[600],
        };
      case 9:
        return {
          'name': 'Elite',
          'description': 'Vous faites partie de l\'élite des utilisateurs !',
          'emoji': '🏆',
          'color': Colors.purple[600],
        };
      case 19:
        return {
          'name': 'Maître',
          'description': 'Votre maîtrise est exceptionnelle !',
          'emoji': '👑',
          'color': Colors.red[600],
        };
      case 29:
        return {
          'name': 'Champion',
          'description': 'Vous êtes un véritable champion !',
          'emoji': '🌟',
          'color': Colors.amber[600],
        };
      case 39:
        return {
          'name': 'Légende',
          'description': 'Votre légende inspire les autres !',
          'emoji': '⚡',
          'color': Colors.deepPurple[600],
        };
      default:
        // Pour les niveaux de badges non définis spécifiquement
        if (level >= 49) {
          return {
            'name': 'Transcendant',
            'description': 'Vous avez transcendé tous les niveaux !',
            'emoji': '🌌',
            'color': Colors.deepPurple[800],
          };
        } else {
          return {
            'name': 'Badge Niveau $level',
            'description': 'Badge exceptionnel de niveau $level',
            'emoji': '🏅',
            'color': Colors.amber[600],
          };
        }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'level': level,
      'color': color.value,
      'unlockedAt': unlockedAt.millisecondsSinceEpoch,
    };
  }

  factory AuraBadge.fromJson(Map<String, dynamic> json) {
    return AuraBadge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      emoji: json['emoji'],
      level: json['level'],
      color: Color(json['color']),
      unlockedAt: DateTime.fromMillisecondsSinceEpoch(json['unlockedAt']),
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

// Classe pour les badges spéciaux
class SpecialBadge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String type;
  final DateTime unlockedAt;

  SpecialBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
    required this.unlockedAt,
  });

  static SpecialBadge createLightningBadge() {
    return SpecialBadge(
      id: 'special_lightning',
      name: 'Éclair',
      description: '3 objectifs complétés en une semaine !',
      emoji: '⚡',
      type: 'lightning',
      unlockedAt: DateTime.now(),
    );
  }

  static SpecialBadge createMarathonBadge() {
    return SpecialBadge(
      id: 'special_marathon',
      name: 'Marathon',
      description: 'Objectif de 30+ jours terminé !',
      emoji: '🏃‍♂️',
      type: 'marathon',
      unlockedAt: DateTime.now(),
    );
  }

  static SpecialBadge createPerfectionistBadge() {
    return SpecialBadge(
      id: 'special_perfectionist',
      name: 'Perfectionniste',
      description: '5 objectifs terminés avant la deadline !',
      emoji: '🎯',
      type: 'perfectionist',
      unlockedAt: DateTime.now(),
    );
  }

  static SpecialBadge createConsistentBadge() {
    return SpecialBadge(
      id: 'special_consistent',
      name: 'Régulier',
      description: '7 jours consécutifs d\'activité !',
      emoji: '📅',
      type: 'consistent',
      unlockedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'type': type,
      'unlockedAt': unlockedAt.millisecondsSinceEpoch,
    };
  }

  factory SpecialBadge.fromJson(Map<String, dynamic> json) {
    return SpecialBadge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      emoji: json['emoji'],
      type: json['type'],
      unlockedAt: DateTime.fromMillisecondsSinceEpoch(json['unlockedAt']),
    );
  }
}
