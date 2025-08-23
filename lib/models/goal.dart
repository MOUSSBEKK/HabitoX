import 'package:flutter/material.dart';

enum GoalGrade {
  novice('Novice', '🥉', 0, Colors.brown),
  apprentice('Apprenti', '🥈', 10, Colors.grey),
  adept('Adepte', '🥇', 25, Colors.amber),
  expert('Expert', '💎', 50, Colors.blue),
  master('Maître', '👑', 100, Colors.purple),
  grandmaster('Grand Maître', '🌟', 200, Colors.red),
  legend('Légende', '🔥', 500, Colors.orange);

  const GoalGrade(this.title, this.emoji, this.minDays, this.color);

  final String title;
  final String emoji;
  final int minDays;
  final Color color;

  static GoalGrade getGradeForDays(int days) {
    for (int i = GoalGrade.values.length - 1; i >= 0; i--) {
      if (days >= GoalGrade.values[i].minDays) {
        return GoalGrade.values[i];
      }
    }
    return GoalGrade.novice;
  }

  GoalGrade? get nextGrade {
    final currentIndex = GoalGrade.values.indexOf(this);
    if (currentIndex < GoalGrade.values.length - 1) {
      return GoalGrade.values[currentIndex + 1];
    }
    return null;
  }
}

class Goal {
  final String id;
  String title;
  String description;
  IconData icon;
  Color color;
  double progress;
  int targetDays;
  int currentStreak;
  int totalDays;
  DateTime createdAt;
  DateTime? lastUpdated;
  bool isActive;
  bool isCompleted;
  DateTime? completedAt;
  List<DateTime> completedSessions;
  int maxStreak;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.progress = 0.0,
    this.targetDays = 30,
    this.currentStreak = 0,
    this.totalDays = 0,
    required this.createdAt,
    this.lastUpdated,
    this.isActive = true,
    this.isCompleted = false,
    this.completedAt,
    List<DateTime>? completedSessions,
    this.maxStreak = 0,
  }) : completedSessions = completedSessions ?? [];

  GoalGrade get currentGrade => GoalGrade.getGradeForDays(totalDays);
  GoalGrade? get nextGrade => currentGrade.nextGrade;

  double get progressToNextGrade {
    final nextGrade = this.nextGrade;
    if (nextGrade == null) return 1.0;

    final progress =
        (totalDays - currentGrade.minDays) /
        (nextGrade.minDays - currentGrade.minDays);
    return progress.clamp(0.0, 1.0);
  }

  bool get isOnTrack =>
      currentStreak >= 3; // Considéré "sur la bonne voie" après 3 jours
  bool get isStruggling =>
      currentStreak == 0 && totalDays > 0; // En difficulté si pas de streak
  bool get isConsistent => currentStreak >= 7; // Consistant après 7 jours

  String get motivationMessage {
    if (isCompleted) return "🎉 Objectif accompli ! Vous êtes incroyable !";
    if (isConsistent)
      return "🔥 Incroyable ! Vous maintenez une série parfaite !";
    if (isOnTrack)
      return "💪 Continuez comme ça ! Vous êtes sur la bonne voie !";
    if (isStruggling) return "💪 Ne lâchez rien ! Chaque jour compte !";
    return "🚀 Commencez votre voyage vers le succès !";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'color': color.value,
      'progress': progress,
      'targetDays': targetDays,
      'currentStreak': currentStreak,
      'totalDays': totalDays,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUpdated': lastUpdated?.millisecondsSinceEpoch,
      'isActive': isActive,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'completedSessions': completedSessions
          .map((d) => d.millisecondsSinceEpoch)
          .toList(),
      'maxStreak': maxStreak,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: IconData(
        json['iconCodePoint'],
        fontFamily: json['iconFontFamily'],
        fontPackage: json['iconFontPackage'],
      ),
      color: Color(json['color']),
      progress: json['progress']?.toDouble() ?? 0.0,
      targetDays: json['targetDays'] ?? 30,
      currentStreak: json['currentStreak'] ?? 0,
      totalDays: json['totalDays'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastUpdated'])
          : null,
      isActive: json['isActive'] ?? true,
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'])
          : null,
      completedSessions:
          (json['completedSessions'] as List<dynamic>?)
              ?.map((d) => DateTime.fromMillisecondsSinceEpoch(d))
              .toList() ??
          [],
      maxStreak: json['maxStreak'] ?? 0,
    );
  }

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    Color? color,
    double? progress,
    int? targetDays,
    int? currentStreak,
    int? totalDays,
    DateTime? createdAt,
    DateTime? lastUpdated,
    bool? isActive,
    bool? isCompleted,
    DateTime? completedAt,
    List<DateTime>? completedSessions,
    int? maxStreak,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      progress: progress ?? this.progress,
      targetDays: targetDays ?? this.targetDays,
      currentStreak: currentStreak ?? this.currentStreak,
      totalDays: totalDays ?? this.totalDays,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      completedSessions: completedSessions ?? this.completedSessions,
      maxStreak: maxStreak ?? this.maxStreak,
    );
  }
}
