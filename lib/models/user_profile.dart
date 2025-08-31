import 'package:flutter/material.dart';
import 'dart:math';

class UserProfile {
  final String id;
  final String username;
  int level;
  int totalDaysCompleted;
  int consecutiveDays;
  int maxConsecutiveDays;
  DateTime lastActivityDate;
  DateTime createdAt;
  List<Badge> unlockedBadges;

  UserProfile({
    required this.id,
    required this.username,
    this.level = 1,
    this.totalDaysCompleted = 0,
    this.consecutiveDays = 0,
    this.maxConsecutiveDays = 0,
    required this.lastActivityDate,
    required this.createdAt,
    List<Badge>? unlockedBadges,
  }) : unlockedBadges = unlockedBadges ?? [];

  // Calculer le niveau basé sur les jours complétés
  void calculateLevel() {
    // Système simple: commence niveau 1, puis 1 jour complété = 1 niveau supplémentaire
    level = 1 + totalDaysCompleted;
  }

  // Ajouter un jour complété
  bool addDayCompleted() {
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
    } else if (today.difference(lastDay).inDays > 1) {
      // Jour manqué - reset de la série
      consecutiveDays = 1;
    } else {
      // Même jour - pas de changement
      return false;
    }

    // Incrémenter le nombre total de jours complétés
    totalDaysCompleted++;
    lastActivityDate = now;

    // Calculer le nouveau niveau basé sur les jours complétés
    final oldLevel = level;
    calculateLevel();

    // Vérifier si on a monté de niveau
    final leveledUp = level > oldLevel;

    _checkForNewBadges();

    // Retourner si on a monté de niveau
    return leveledUp;
  }

  // Vérifier les nouveaux badges avec progression exponentielle
  void _checkForNewBadges() {
    final newLevel = level;

    // Progression exponentielle pour les badges
    // Badge 1: niveau 2 (après 1 jour complété)
    // Badge 2: niveau 5 (après 4 jours complétés)
    // Badge 3: niveau 10 (après 9 jours complétés)
    // Badge 4: niveau 20 (après 19 jours complétés)
    // Badge 5: niveau 40 (après 39 jours complétés)
    // Badge 6: niveau 80 (après 79 jours complétés)
    // etc.
    final badgeLevels = [2, 5, 10, 20, 40, 80, 160, 320, 640, 1280];

    for (int badgeLevel in badgeLevels) {
      if (newLevel >= badgeLevel) {
        final existingBadge = unlockedBadges
            .where((badge) => badge.level == badgeLevel)
            .firstOrNull;
        if (existingBadge == null) {
          unlockedBadges.add(Badge.createForLevel(badgeLevel));
        }
      }
    }
  }

  // Obtenir la progression vers le prochain niveau
  double get progressToNextLevel {
    // Système simple: chaque jour complété = 1 niveau
    return 0.0; // Toujours 0% car on monte d'un niveau par jour complété
  }

  // Obtenir le nom du niveau
  String get levelName {
    if (level >= 50) return 'Légende';
    if (level >= 40) return 'Maître';
    if (level >= 30) return 'Expert';
    if (level >= 20) return 'Adepte';
    if (level >= 10) return 'Initié';
    if (level >= 5) return 'Apprenti';
    return 'Novice';
  }

  // Obtenir la couleur basée sur le niveau
  Color get levelColor {
    if (level >= 50) return Colors.purple;
    if (level >= 40) return Colors.deepPurple;
    if (level >= 30) return Colors.indigo;
    if (level >= 20) return Colors.blue;
    if (level >= 10) return Colors.teal;
    if (level >= 5) return Colors.green;
    return Colors.grey;
  }

  // Obtenir l'emoji basé sur le niveau
  String get levelEmoji {
    if (level >= 50) return '🌟';
    if (level >= 40) return '✨';
    if (level >= 30) return '💫';
    if (level >= 20) return '⭐';
    if (level >= 10) return '⚡';
    if (level >= 5) return '🔮';
    return '💎';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'level': level,
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
      level: json['level'] ?? 1,
      totalDaysCompleted: json['totalDaysCompleted'] ?? 0,
      consecutiveDays: json['consecutiveDays'] ?? 0,
      maxConsecutiveDays: json['maxConsecutiveDays'] ?? 0,
      lastActivityDate: DateTime.fromMillisecondsSinceEpoch(
        json['lastActivityDate'],
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      unlockedBadges:
          (json['unlockedBadges'] as List<dynamic>?)
              ?.map((badge) => Badge.fromJson(badge))
              .toList() ??
          [],
    );
  }

  UserProfile copyWith({
    String? id,
    String? username,
    int? level,
    int? totalDaysCompleted,
    int? consecutiveDays,
    int? maxConsecutiveDays,
    DateTime? lastActivityDate,
    DateTime? createdAt,
    List<Badge>? unlockedBadges,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      level: level ?? this.level,
      totalDaysCompleted: totalDaysCompleted ?? this.totalDaysCompleted,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      maxConsecutiveDays: maxConsecutiveDays ?? this.maxConsecutiveDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      createdAt: createdAt ?? this.createdAt,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final int level;
  final Color color;
  final DateTime unlockedAt;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.level,
    required this.color,
    required this.unlockedAt,
  });

  static Badge createForLevel(int level) {
    final badgeData = _getBadgeDataForLevel(level);
    return Badge(
      id: 'badge_$level',
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
      case 2:
        return {
          'name': 'Premier Pas',
          'description': 'Votre première session complétée !',
          'emoji': '🎯',
          'color': Colors.green,
        };
      case 5:
        return {
          'name': 'Débutant Assidu',
          'description': '4 jours de persévérance !',
          'emoji': '🔥',
          'color': Colors.orange,
        };
      case 10:
        return {
          'name': 'Habitué Motivé',
          'description': '9 jours de régularité !',
          'emoji': '⚡',
          'color': Colors.blue,
        };
      case 20:
        return {
          'name': 'Expert Consistant',
          'description': '19 jours d\'excellence !',
          'emoji': '⭐',
          'color': Colors.purple,
        };
      case 40:
        return {
          'name': 'Maître Persévérant',
          'description': '39 jours de maîtrise !',
          'emoji': '💎',
          'color': Colors.indigo,
        };
      case 80:
        return {
          'name': 'Légende Vivante',
          'description': '79 jours de légende !',
          'emoji': '🌟',
          'color': Colors.deepPurple,
        };
      case 160:
        return {
          'name': 'Champion Éternel',
          'description': '159 jours de championnat !',
          'emoji': '👑',
          'color': Colors.red,
        };
      case 320:
        return {
          'name': 'Déité de la Discipline',
          'description': '319 jours divins !',
          'emoji': '✨',
          'color': Colors.pink,
        };
      case 640:
        return {
          'name': 'Immortel de l\'Habitude',
          'description': '639 jours d\'immortalité !',
          'emoji': '💫',
          'color': Colors.amber,
        };
      case 1280:
        return {
          'name': 'Univers de la Volonté',
          'description': '1279 jours universels !',
          'emoji': '🌌',
          'color': Colors.cyan,
        };
      default:
        return {
          'name': 'Niveau $level',
          'description': 'Badge de niveau $level',
          'emoji': '🏆',
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

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
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
