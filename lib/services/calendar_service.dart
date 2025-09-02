import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calendar_shape.dart';
import '../models/badge.dart' as models;

class CalendarService extends ChangeNotifier {
  static const String _shapesKey = 'calendarShapes';
  static const String _badgesKey = 'badges';
  static const String _currentShapeKey = 'currentShape';

  List<CalendarShape> _shapes = [];
  List<models.Badge> _badges = [];
  CalendarShape? _currentShape;

  List<CalendarShape> get shapes => _shapes;
  List<models.Badge> get badges => _badges;
  CalendarShape? get currentShape => _currentShape;
  List<models.Badge> get unlockedBadges =>
      _badges.where((badge) => badge.isUnlocked).toList();
  List<models.Badge> get lockedBadges =>
      _badges.where((badge) => !badge.isUnlocked).toList();

  CalendarService() {
    _initializeShapes();
    _loadData();
  }

  void _initializeShapes() {
    if (_shapes.isEmpty) {
      // Generate 10 initial random shapes
      for (int i = 0; i < 10; i++) {
        _shapes.add(CalendarShape.generateRandomShape());
      }
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load shapes
    final shapesJson = prefs.getStringList(_shapesKey);
    if (shapesJson != null) {
      _shapes = shapesJson
          .map((json) => CalendarShape.fromJson(jsonDecode(json)))
          .toList();
    }

    // Load badges
    final badgesJson = prefs.getStringList(_badgesKey);
    if (badgesJson != null) {
      _badges = badgesJson
          .map((json) => models.Badge.fromJson(jsonDecode(json)))
          .toList();
    }

    // Load current shape
    final currentShapeId = prefs.getString(_currentShapeKey);
    if (currentShapeId != null) {
      try {
        _currentShape = _shapes.firstWhere(
          (shape) => shape.id == currentShapeId,
        );
      } catch (e) {
        _currentShape = _shapes.isNotEmpty ? _shapes.first : null;
      }
    } else if (_shapes.isNotEmpty) {
      _currentShape = _shapes.first;
    }

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save shapes
    final shapesJson = _shapes
        .map((shape) => jsonEncode(shape.toJson()))
        .toList();
    await prefs.setStringList(_shapesKey, shapesJson);

    // Save badges
    final badgesJson = _badges
        .map((badge) => jsonEncode(badge.toJson()))
        .toList();
    await prefs.setStringList(_badgesKey, badgesJson);

    // Save current shape
    if (_currentShape != null) {
      await prefs.setString(_currentShapeKey, _currentShape!.id);
    }
  }

  Future<void> generateNewShape() async {
    final newShape = CalendarShape.generateRandomShape();
    _shapes.add(newShape);

    _currentShape ??= newShape;

    await _saveData();
    notifyListeners();
  }

  Future<void> setCurrentShape(String shapeId) async {
    final shape = _shapes.firstWhere((s) => s.id == shapeId);
    _currentShape = shape;
    await _saveData();
    notifyListeners();
  }

  // Ensure there is a current shape that matches the active goal target days.
  // If a matching shape exists (same totalDays), select it. Otherwise create one.
  Future<void> ensureShapeForTargetDays(int targetDays, {Color? goalColor}) async {
    if (targetDays <= 0) return;

    // Try to find an existing shape with same totalDays
    final existing = _shapes.where((s) => s.totalDays == targetDays).toList();
    if (existing.isNotEmpty) {
      // If we have a goalColor, update the existing shape's color
      if (goalColor != null) {
        final existingShape = existing.first;
        final updatedShape = existingShape.copyWith(color: goalColor);
        final shapeIndex = _shapes.indexWhere((s) => s.id == existingShape.id);
        if (shapeIndex != -1) {
          _shapes[shapeIndex] = updatedShape;
          _currentShape = updatedShape;
        } else {
          _currentShape = existingShape;
        }
      } else {
        _currentShape = existing.first;
      }
      await _saveData();
      notifyListeners();
      return;
    }

    // Create a new tailored heatmap shape
    final newShape = CalendarShape.createForTargetDays(targetDays, goalColor: goalColor);
    _shapes.add(newShape);
    _currentShape = newShape;
    await _saveData();
    notifyListeners();
  }

  Future<void> unlockBadge(CalendarShape shape) async {
    // Check if badge already exists
    final existingBadge = _badges
        .where((badge) => badge.calendarShape.id == shape.id)
        .firstOrNull;

    if (existingBadge == null) {
      final newBadge = models.Badge.createFromCalendarShape(shape);
      _badges.add(newBadge);

      // Mark shape as unlocked
      final shapeIndex = _shapes.indexWhere((s) => s.id == shape.id);
      if (shapeIndex != -1) {
        _shapes[shapeIndex] = _shapes[shapeIndex].copyWith(isUnlocked: true);
      }

      await _saveData();
      notifyListeners();
    }
  }

  Future<void> resetProgress() async {
    // Reset all shapes to locked
    for (int i = 0; i < _shapes.length; i++) {
      _shapes[i] = _shapes[i].copyWith(isUnlocked: false);
    }

    // Clear all badges
    _badges.clear();

    // Set first shape as current
    if (_shapes.isNotEmpty) {
      _currentShape = _shapes.first;
    }

    await _saveData();
    notifyListeners();
  }

  int get totalShapes => _shapes.length;
  int get unlockedShapes => _shapes.where((shape) => shape.isUnlocked).length;
  int get totalBadges => _badges.length;
  int get unlockedBadgesCount => unlockedBadges.length;
}
