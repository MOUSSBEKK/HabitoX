import 'package:flutter/material.dart';
import 'dart:math';

class CalendarShape {
  final String id;
  final String name;
  final Color color;
  final List<List<bool>> pattern;
  final int totalDays;

  CalendarShape({
    required this.id,
    required this.name,
    required this.color,
    required this.pattern,
    required this.totalDays,
  });

  CalendarShape copyWith({
    String? id,
    String? name,
    Color? color,
    List<List<bool>>? pattern,
    int? totalDays,
    bool? isUnlocked,
  }) {
    return CalendarShape(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      pattern: pattern ?? this.pattern,
      totalDays: totalDays ?? this.totalDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'pattern': pattern
          .map((row) => row.map((cell) => cell).toList())
          .toList(),
      'totalDays': totalDays,
    };
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
      name: 'Objectif $targetDays jours',
      color:
          goalColor ??
          Colors.green, // mettre la couleur de l'application par défaut
      pattern: pattern,
      totalDays: targetDays,
    );
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
