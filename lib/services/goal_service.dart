import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';
import '../models/calendar_shape.dart';

class GoalService extends ChangeNotifier {
  static const String _goalsKey = 'goals';
  static const String _activeGoalKey = 'activeGoal';
  List<Goal> _goals = [];
  Goal? _activeGoal;

  List<Goal> get goals => _goals;
  Goal? get activeGoal => _activeGoal;
  List<Goal> get completedGoals =>
      _goals.where((goal) => goal.isCompleted).toList();
  List<Goal> get archivedGoals =>
      _goals.where((goal) => !goal.isActive && !goal.isCompleted).toList();

  // Icônes prédéfinies pour les objectifs
  static final List<Map<String, dynamic>> predefinedIcons = [
    {'icon': Icons.fitness_center, 'name': 'Fitness', 'color': Colors.red},
    {'icon': Icons.music_note, 'name': 'Musique', 'color': Colors.purple},
    {'icon': Icons.book, 'name': 'Lecture', 'color': Colors.blue},
    {'icon': Icons.code, 'name': 'Programmation', 'color': Colors.green},
    {'icon': Icons.language, 'name': 'Langues', 'color': Colors.orange},
    {'icon': Icons.brush, 'name': 'Art', 'color': Colors.pink},
    {'icon': Icons.psychology, 'name': 'Méditation', 'color': Colors.indigo},
    {'icon': Icons.sports_soccer, 'name': 'Sport', 'color': Colors.teal},
    {'icon': Icons.restaurant, 'name': 'Cuisine', 'color': Colors.amber},
    {'icon': Icons.work, 'name': 'Travail', 'color': Colors.brown},
    {'icon': Icons.school, 'name': 'Études', 'color': Colors.cyan},
    {
      'icon': Icons.volunteer_activism,
      'name': 'Bénévolat',
      'color': Colors.deepOrange,
    },
  ];

  GoalService() {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getStringList(_goalsKey) ?? [];
    final activeGoalId = prefs.getString(_activeGoalKey);

    _goals = goalsJson.map((json) => Goal.fromJson(jsonDecode(json))).toList();

    if (activeGoalId != null) {
      try {
        _activeGoal = _goals.firstWhere(
          (goal) =>
              goal.id == activeGoalId && goal.isActive && !goal.isCompleted,
        );
      } catch (e) {
        try {
          _activeGoal = _goals.firstWhere(
            (goal) => goal.isActive && !goal.isCompleted,
          );
        } catch (e) {
          _activeGoal = _goals.isNotEmpty ? _goals.first : null;
        }
      }
    } else if (_goals.isNotEmpty) {
      _activeGoal = _goals.firstWhere(
        (goal) => goal.isActive && !goal.isCompleted,
        orElse: () => _goals.first,
      );
    }

    notifyListeners();
  }

  Future<void> _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = _goals.map((goal) => jsonEncode(goal.toJson())).toList();

    await prefs.setStringList(_goalsKey, goalsJson);

    if (_activeGoal != null) {
      await prefs.setString(_activeGoalKey, _activeGoal!.id);
    }
  }

  Future<void> addGoal(Goal goal) async {
    // Si on ajoute un nouvel objectif, on désactive tous les autres
    if (_activeGoal != null) {
      await _deactivateAllGoals();
    }

    _goals.add(goal);
    _activeGoal = goal;
    await _saveGoals();
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;

      // Si c'est l'objectif actif, on le met à jour
      if (_activeGoal?.id == goal.id) {
        _activeGoal = goal;
      }

      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((goal) => goal.id == goalId);

    // Si on supprime l'objectif actif, on en sélectionne un autre
    if (_activeGoal?.id == goalId) {
      _activeGoal = _goals.isNotEmpty ? _goals.first : null;
    }

    await _saveGoals();
    notifyListeners();
  }

  Future<void> activateGoal(String goalId) async {
    // Désactiver tous les autres objectifs
    await _deactivateAllGoals();

    // Activer l'objectif sélectionné
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      _activeGoal = _goals[index];
      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> _deactivateAllGoals() async {
    for (int i = 0; i < _goals.length; i++) {
      if (_goals[i].isActive && !_goals[i].isCompleted) {
        _goals[i] = _goals[i].copyWith(
          isActive: false,
          lastUpdated: DateTime.now(),
        );
      }
    }
    _activeGoal = null;
  }

  Future<void> completeGoal(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      _goals[index] = goal.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        isActive: false,
        lastUpdated: DateTime.now(),
      );

      // Si c'était l'objectif actif, on le retire
      if (_activeGoal?.id == goalId) {
        _activeGoal = null;
      }

      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> updateProgress(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Vérifier si on a déjà marqué une session aujourd'hui
      final alreadyCompletedToday = goal.completedSessions.any(
        (session) =>
            DateTime(session.year, session.month, session.day) == today,
      );

      if (!alreadyCompletedToday) {
        final newTotalDays = goal.totalDays + 1;
        final newStreak = goal.currentStreak + 1;
        final newMaxStreak = newStreak > goal.maxStreak
            ? newStreak
            : goal.maxStreak;
        final newProgress = newTotalDays / goal.targetDays;

        // Ajouter la session d'aujourd'hui
        final newCompletedSessions = List<DateTime>.from(goal.completedSessions)
          ..add(now);

        _goals[index] = goal.copyWith(
          progress: newProgress.clamp(0.0, 1.0),
          totalDays: newTotalDays,
          currentStreak: newStreak,
          maxStreak: newMaxStreak,
          lastUpdated: now,
          completedSessions: newCompletedSessions,
        );

        // Vérifier si l'objectif est complété
        if (newProgress >= 1.0) {
          await completeGoal(goalId);
        } else {
          await _saveGoals();
          notifyListeners();
        }
      }
    }
  }

  Future<void> resetStreak(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        currentStreak: 0,
        lastUpdated: DateTime.now(),
      );

      if (_activeGoal?.id == goalId) {
        _activeGoal = _goals[index];
      }

      await _saveGoals();
      notifyListeners();
    }
  }

  // Statistiques globales
  int get totalCompletedGoals => completedGoals.length;
  int get totalDaysAcrossAllGoals =>
      _goals.fold(0, (sum, goal) => sum + goal.totalDays);
  int get bestStreakEver => _goals.fold(
    0,
    (best, goal) => goal.maxStreak > best ? goal.maxStreak : best,
  );

  GoalGrade get highestGradeAchieved {
    if (_goals.isEmpty) return GoalGrade.novice;

    GoalGrade highest = GoalGrade.novice;
    for (final goal in _goals) {
      if (goal.currentGrade.index > highest.index) {
        highest = goal.currentGrade;
      }
    }
    return highest;
  }

  // Method to check if a calendar shape should be unlocked based on goal progress
  bool shouldUnlockCalendarShape(CalendarShape shape) {
    if (_goals.isEmpty) return false;

    // Check if any active goal has enough progress to unlock the shape
    for (final goal in _goals) {
      if (goal.isActive && goal.totalDays >= shape.totalDays) {
        return true;
      }
    }
    return false;
  }
}
