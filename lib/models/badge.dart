import 'package:flutter/material.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final Color color;
  final DateTime unlockedAt;
  final bool isUnlocked;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.unlockedAt,
    this.isUnlocked = false,
  });

  Badge copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    Color? color,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value,
      'unlockedAt': unlockedAt.millisecondsSinceEpoch,
      'isUnlocked': isUnlocked,
    };
  }
}
