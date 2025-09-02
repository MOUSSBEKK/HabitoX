import 'package:flutter/material.dart';
import 'dart:math';

enum CalendarShapeType {
  flyingSaucer('Soucoupe Volante', '🛸'),
  rocket('Fusée', '🚀'),
  star('Étoile', '⭐'),
  heart('Cœur', '❤️'),
  diamond('Diamant', '💎'),
  crown('Couronne', '👑'),
  butterfly('Papillon', '🦋'),
  tree('Arbre', '🌳'),
  flower('Fleur', '🌸'),
  lightning('Éclair', '⚡');

  const CalendarShapeType(this.name, this.emoji);
  final String name;
  final String emoji;
}

class CalendarShape {
  final String id;
  final CalendarShapeType type;
  final String name;
  final String emoji;
  final Color color;
  final List<List<bool>> pattern;
  final int totalDays;
  final bool isUnlocked;

  CalendarShape({
    required this.id,
    required this.type,
    required this.name,
    required this.emoji,
    required this.color,
    required this.pattern,
    required this.totalDays,
    this.isUnlocked = false,
  });

  CalendarShape copyWith({
    String? id,
    CalendarShapeType? type,
    String? name,
    String? emoji,
    Color? color,
    List<List<bool>>? pattern,
    int? totalDays,
    bool? isUnlocked,
  }) {
    return CalendarShape(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      pattern: pattern ?? this.pattern,
      totalDays: totalDays ?? this.totalDays,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'emoji': emoji,
      'color': color.value,
      'pattern': pattern
          .map((row) => row.map((cell) => cell).toList())
          .toList(),
      'totalDays': totalDays,
      'isUnlocked': isUnlocked,
    };
  }

  factory CalendarShape.fromJson(Map<String, dynamic> json) {
    return CalendarShape(
      id: json['id'],
      type: CalendarShapeType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'],
      emoji: json['emoji'],
      color: Color(json['color']),
      pattern: (json['pattern'] as List<dynamic>)
          .map(
            (row) =>
                (row as List<dynamic>).map((cell) => cell as bool).toList(),
          )
          .toList(),
      totalDays: json['totalDays'],
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }

  static CalendarShape generateRandomShape() {
    final random = Random();
    final type = CalendarShapeType
        .values[random.nextInt(CalendarShapeType.values.length)];
    final color = _generateRandomColor();

    // Generate a random pattern (7x7 grid for weekly view)
    final pattern = _generateRandomPattern();
    final totalDays = _countTrueCells(pattern);

    return CalendarShape(
      id: _generateId(),
      type: type,
      name: type.name,
      emoji: type.emoji,
      color: color,
      pattern: pattern,
      totalDays: totalDays,
    );
  }

  static List<List<bool>> _generateRandomPattern() {
    final random = Random();
    final pattern = <List<bool>>[];

    // Generate a 7x7 grid (7 weeks)
    for (int week = 0; week < 7; week++) {
      final weekPattern = <bool>[];
      for (int day = 0; day < 7; day++) {
        // Higher probability for weekdays (Monday-Friday)
        if (day < 5) {
          weekPattern.add(random.nextDouble() < 0.7); // 70% chance for weekdays
        } else {
          weekPattern.add(random.nextDouble() < 0.4); // 40% chance for weekends
        }
      }
      pattern.add(weekPattern);
    }

    return pattern;
  }

  // Generate a rectangular heatmap pattern (weeks x 7 days)
  // that contains exactly `targetDays` visible cells, filled sequentially.
  static List<List<bool>> generateHeatmapPatternForTargetDays(int targetDays) {
    if (targetDays <= 0) {
      return [List<bool>.filled(7, false)];
    }

    final weeks = (targetDays / 7).ceil();
    final pattern = <List<bool>>[];
    int remaining = targetDays;

    for (int week = 0; week < weeks; week++) {
      final weekPattern = <bool>[];
      for (int day = 0; day < 7; day++) {
        if (remaining > 0) {
          weekPattern.add(true);
          remaining--;
        } else {
          weekPattern.add(false);
        }
      }
      pattern.add(weekPattern);
    }

    return pattern;
  }

  // Create a heatmap CalendarShape tailored for a goal with `targetDays`.
  // Name is explicit to reflect the goal target, while type is set to a default.
  static CalendarShape createForTargetDays(int targetDays, {Color? goalColor}) {
    final pattern = generateHeatmapPatternForTargetDays(targetDays);
    return CalendarShape(
      id: _generateId(),
      type: CalendarShapeType.star,
      name: 'Objectif $targetDays jours',
      emoji: '⭐',
      color: goalColor ?? _generateRandomColor(),
      pattern: pattern,
      totalDays: targetDays,
    );
  }

  static int _countTrueCells(List<List<bool>> pattern) {
    int count = 0;
    for (final row in pattern) {
      for (final cell in row) {
        if (cell) count++;
      }
    }
    return count;
  }

  static Color _generateRandomColor() {
    final random = Random();
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[random.nextInt(colors.length)];
  }

  static String _generateId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
