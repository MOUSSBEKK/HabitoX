import 'package:flutter/material.dart';
import 'calendar_shape.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final Color color;
  final CalendarShape calendarShape;
  final DateTime unlockedAt;
  final bool isUnlocked;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
    required this.calendarShape,
    required this.unlockedAt,
    this.isUnlocked = false,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    Color? color,
    CalendarShape? calendarShape,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      calendarShape: calendarShape ?? this.calendarShape,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'emoji': emoji,
      'color': color.value,
      'calendarShape': calendarShape.toJson(),
      'unlockedAt': unlockedAt.millisecondsSinceEpoch,
      'isUnlocked': isUnlocked,
    };
  }

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      emoji: json['emoji'],
      color: Color(json['color']),
      calendarShape: CalendarShape.fromJson(json['calendarShape']),
      unlockedAt: DateTime.fromMillisecondsSinceEpoch(json['unlockedAt']),
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  static Badge createFromCalendarShape(CalendarShape shape) {
    return Badge(
      id: _generateId(),
      name: '${shape.name} Maître',
      description: 'A complété le calendrier ${shape.name} à 100%',
      emoji: shape.emoji,
      color: shape.color,
      calendarShape: shape,
      unlockedAt: DateTime.now(),
      isUnlocked: true,
    );
  }

  static String _generateId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'badge_$random';
  }
}
