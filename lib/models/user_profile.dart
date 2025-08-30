import 'package:flutter/material.dart';
import 'dart:math';

class UserProfile {
  final String id;
  final String username;
  int auraPoints;
  int auraLevel;
  int totalDaysCompleted;
  int consecutiveDays;
  int maxConsecutiveDays;
  DateTime lastActivityDate;
  DateTime createdAt;
  List<AuraBadge> unlockedBadges;

  UserProfile({
    required this.id,
    required this.username,
    this.auraPoints = 0,
    this.auraLevel = 1,
    this.totalDaysCompleted = 0,
    this.consecutiveDays = 0,
    this.maxConsecutiveDays = 0,
    required this.lastActivityDate,
    required this.createdAt,
    List<AuraBadge>? unlockedBadges,
  }) : unlockedBadges = unlockedBadges ?? [];

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
      } else if (consecutiveDays >= 3)
        bonus = 20; // 3 jours = +20

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

    // Vérifier le premier badge au niveau 1
    if (newLevel >= 1) {
      final existingBadge = unlockedBadges
          .where((badge) => badge.level == 1)
          .firstOrNull;
      if (existingBadge == null) {
        unlockedBadges.add(AuraBadge.createForLevel(1));
      }
    }

    // Vérifier les autres badges tous les 5 niveaux (5, 10, 15, 20, 25, etc.)
    for (int level = 5; level <= newLevel; level += 5) {
      final existingBadge = unlockedBadges
          .where((badge) => badge.level == level)
          .firstOrNull;
      if (existingBadge == null) {
        unlockedBadges.add(AuraBadge.createForLevel(level));
      }
    }
  }

  // Obtenir la progression vers le prochain niveau
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
      'auraPoints': auraPoints,
      'auraLevel': auraLevel,
      'totalDaysCompleted': totalDaysCompleted,
      'consecutiveDays': consecutiveDays,
      'maxConsecutiveDays': maxConsecutiveDays,
      'lastActivityDate': lastActivityDate.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'unlockedBadges': unlockedBadges.map((badge) => badge.toJson()).toList(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
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
    );
  }

  UserProfile copyWith({
    String? id,
    String? username,
    int? auraPoints,
    int? auraLevel,
    int? totalDaysCompleted,
    int? consecutiveDays,
    int? maxConsecutiveDays,
    DateTime? lastActivityDate,
    DateTime? createdAt,
    List<AuraBadge>? unlockedBadges,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      auraPoints: auraPoints ?? this.auraPoints,
      auraLevel: auraLevel ?? this.auraLevel,
      totalDaysCompleted: totalDaysCompleted ?? this.totalDaysCompleted,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      createdAt: createdAt ?? this.createdAt,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
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
          'name': 'Apprenti Brillant',
          'description': 'Premier pas dans le monde de l\'aura',
          'emoji': '🔮',
          'color': Colors.green,
        };
      case 5:
        return {
          'name': 'Initié Radieux',
          'description': 'L\'aura commence à briller',
          'emoji': '⚡',
          'color': Colors.teal,
        };
      case 10:
        return {
          'name': 'Adepte Lumineux',
          'description': 'La lumière de l\'aura grandit',
          'emoji': '⭐',
          'color': Colors.blue,
        };
      case 15:
        return {
          'name': 'Gardien Céleste',
          'description': 'Protecteur de l\'énergie astrale',
          'emoji': '💫',
          'color': Colors.indigo,
        };
      case 20:
        return {
          'name': 'Maître Éthéré',
          'description': 'Maîtrise des forces éthérées',
          'emoji': '✨',
          'color': Colors.deepPurple,
        };
      case 25:
        return {
          'name': 'Légende Astrale',
          'description': 'Légende vivante de l\'aura',
          'emoji': '🌟',
          'color': Colors.purple,
        };
      default:
        return {
          'name': 'Niveau $level',
          'description': 'Badge de niveau $level',
          'emoji': '💎',
          'color': Colors.grey,
        };
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
