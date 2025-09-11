import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';
import '../models/user_profile.dart';
import 'user_profile_service.dart';

class GoalService extends ChangeNotifier {
  static const String _goalsKey = 'goals';
  static const String _activeGoalsKey = 'activeGoals';
  List<Goal> _goals = [];
  List<Goal> _activeGoals = [];

  List<Goal> get goals => _goals;
  List<Goal> get activeGoals => _activeGoals;
  Goal? get activeGoal => _activeGoals.isNotEmpty ? _activeGoals.first : null;
  List<Goal> get completedGoals =>
      _goals.where((goal) => goal.isCompleted).toList();
  List<Goal> get archivedGoals =>
      _goals.where((goal) => !goal.isActive && !goal.isCompleted).toList();

  // Icônes prédéfinies pour les objectifs
  // static final List<Map<String, dynamic>> predefinedIcons = [
  //   {'icon': Icons.fitness_center, 'name': 'Fitness', 'color': Colors.red},
  //   {'icon': Icons.music_note, 'name': 'Musique', 'color': Colors.purple},
  //   {'icon': Icons.book, 'name': 'Lecture', 'color': Colors.blue},
  //   {'icon': Icons.code, 'name': 'Programmation', 'color': Colors.green},
  //   {'icon': Icons.language, 'name': 'Langues', 'color': Colors.orange},
  //   {'icon': Icons.brush, 'name': 'Art', 'color': Colors.pink},
  //   {'icon': Icons.psychology, 'name': 'Méditation', 'color': Colors.indigo},
  //   {'icon': Icons.sports_soccer, 'name': 'Sport', 'color': Colors.teal},
  //   {'icon': Icons.restaurant, 'name': 'Cuisine', 'color': Colors.amber},
  //   {'icon': Icons.work, 'name': 'Travail', 'color': Colors.brown},
  //   {'icon': Icons.school, 'name': 'Études', 'color': Colors.cyan},
  //   {
  //     'icon': Icons.volunteer_activism,
  //     'name': 'Bénévolat',
  //     'color': Colors.deepOrange,
  //   },
  // ];

  GoalService() {
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    await initLocalStorage();
    // 1) Lire depuis localstorage (source de vérité)
    final String? storedGoalsJson = localStorage.getItem(_goalsKey);
    final String? storedActiveGoalsJson = localStorage.getItem(_activeGoalsKey);
    List<dynamic> rawGoalsList = [];
    List<dynamic> rawActiveGoalsList = [];

    if (storedGoalsJson != null) {
      try {
        final decoded = jsonDecode(storedGoalsJson);
        if (decoded is List) {
          rawGoalsList = decoded;
        }
      } catch (_) {
        rawGoalsList = [];
      }
    }

    if (storedActiveGoalsJson != null) {
      try {
        final decoded = jsonDecode(storedActiveGoalsJson);
        if (decoded is List) {
          rawActiveGoalsList = decoded;
        }
      } catch (_) {
        rawActiveGoalsList = [];
      }
    } else {
      // 2) Migration depuis SharedPreferences (ancienne version)
      try {
        final prefs = await SharedPreferences.getInstance();
        final goalsJsonList = prefs.getStringList(_goalsKey) ?? [];
        rawGoalsList = goalsJsonList.map((json) => jsonDecode(json)).toList();
        final activeGoalId = prefs.getString('activeGoal');

        // Sauvegarder dans localstorage au nouveau format (liste de maps)
        localStorage.setItem(_goalsKey, jsonEncode(rawGoalsList));
        if (activeGoalId != null) {
          // Migration: créer une liste avec l'ancien objectif actif
          rawActiveGoalsList = [activeGoalId];
          localStorage.setItem(_activeGoalsKey, jsonEncode(rawActiveGoalsList));
        }
      } catch (_) {
        rawGoalsList = [];
        rawActiveGoalsList = [];
      }
    }

    _goals = rawGoalsList.map<Goal>((raw) {
      if (raw is Map<String, dynamic>) {
        return Goal.fromJson(raw);
      }
      if (raw is Map) {
        return Goal.fromJson(Map<String, dynamic>.from(raw));
      }
      return Goal.fromJson(jsonDecode(raw.toString()));
    }).toList();

    // Charger les objectifs actifs par priorité
    _activeGoals = [];
    for (final activeGoalId in rawActiveGoalsList) {
      try {
        final goal = _goals.firstWhere(
          (goal) => goal.id == activeGoalId && goal.isActive && !goal.isCompleted,
        );
        _activeGoals.add(goal);
      } catch (e) {
        // Objectif introuvable, on l'ignore
      }
    }

    // Trier par priorité (1 = plus haute priorité)
    _activeGoals.sort((a, b) => a.priority.compareTo(b.priority));

    // Si aucun objectif actif mais qu'il y a des objectifs, prendre le premier
    if (_activeGoals.isEmpty && _goals.isNotEmpty) {
      final firstActiveGoal = _goals.firstWhere(
        (goal) => goal.isActive && !goal.isCompleted,
        orElse: () => _goals.first,
      );
      _activeGoals.add(firstActiveGoal);
    }

    notifyListeners();
  }

  Future<void> _saveGoals() async {
    await initLocalStorage();
    final goalsList = _goals.map((goal) => goal.toJson()).toList();
    localStorage.setItem(_goalsKey, jsonEncode(goalsList));
    
    final activeGoalsIds = _activeGoals.map((goal) => goal.id).toList();
    localStorage.setItem(_activeGoalsKey, jsonEncode(activeGoalsIds));
  }

  Future<void> addGoal(Goal goal) async {
    _goals.add(goal);
    
    // Ajouter l'objectif aux objectifs actifs si on n'a pas encore 3 objectifs actifs
    if (_activeGoals.length < 3) {
      _activeGoals.add(goal);
      _activeGoals.sort((a, b) => a.priority.compareTo(b.priority));
    }
    
    await _saveGoals();
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;

      // Mettre à jour dans les objectifs actifs si présent
      final activeIndex = _activeGoals.indexWhere((g) => g.id == goal.id);
      if (activeIndex != -1) {
        _activeGoals[activeIndex] = goal;
        _activeGoals.sort((a, b) => a.priority.compareTo(b.priority));
      }

      await _saveGoals();
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((goal) => goal.id == goalId);
    _activeGoals.removeWhere((goal) => goal.id == goalId);

    await _saveGoals();
    notifyListeners();
  }

  Future<void> activateGoal(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index].copyWith(
        isActive: true,
        lastUpdated: DateTime.now(),
      );
      _goals[index] = goal;

      // Ajouter aux objectifs actifs si on n'a pas encore 3 objectifs actifs
      if (_activeGoals.length < 3 && !_activeGoals.any((g) => g.id == goalId)) {
        _activeGoals.add(goal);
        _activeGoals.sort((a, b) => a.priority.compareTo(b.priority));
      }

      await _saveGoals();
      notifyListeners();
    }
  }


  Future<void> completeGoal(
    String goalId, [
    UserProfileService? profileService,
  ]) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      _goals[index] = goal.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        isActive: false,
        lastUpdated: DateTime.now(),
      );

      // Retirer des objectifs actifs
      _activeGoals.removeWhere((g) => g.id == goalId);

      await _saveGoals();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> updateProgress(
    String goalId, [
    UserProfileService? profileService,
  ]) async {
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

        // Mettre à jour dans les objectifs actifs si présent
        final activeIndex = _activeGoals.indexWhere((g) => g.id == goal.id);
        if (activeIndex != -1) {
          _activeGoals[activeIndex] = _goals[index];
        }

        // Vérifier si l'objectif est complété
        if (newProgress >= 1.0) {
          final result = await completeGoalWithXPAndReturn(
            goalId,
            profileService,
            goal.targetDays,
            completedEarly: true,
          );
          return {
            'goalCompleted': true,
            'xpGained': result['xpGained'],
            'levelUpResult': result['levelUpResult'],
          };
        } else {
          await _saveGoals();
          notifyListeners();
          return {'goalCompleted': false, 'sessionCompleted': true};
        }
      }
    }
    return null;
  }

  // Nouvelle méthode pour terminer un objectif avec système XP
  Future<void> completeGoalWithXP(
    String goalId,
    UserProfileService? profileService,
    int targetDays, {
    bool completedEarly = false,
  }) async {
    await completeGoalWithXPAndReturn(
      goalId,
      profileService,
      targetDays,
      completedEarly: completedEarly,
    );
  }

  // Méthode qui retourne les informations de completion
  Future<Map<String, dynamic>> completeGoalWithXPAndReturn(
    String goalId,
    UserProfileService? profileService,
    int targetDays, {
    bool completedEarly = false,
  }) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      _goals[index] = goal.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        isActive: false,
        lastUpdated: DateTime.now(),
      );

      // Retirer des objectifs actifs
      _activeGoals.removeWhere((g) => g.id == goalId);

      LevelUpResult? levelUpResult;
      int xpGained = 0;

      // Ajouter XP avec nouveau système
      if (profileService != null) {
        xpGained = UserProfile.calculateGoalXp(
          targetDays,
          completedEarly: completedEarly,
        );
        levelUpResult = await profileService.onGoalCompletedXP(
          targetDays,
          completedEarly: completedEarly,
        );
      }

      await _saveGoals();
      notifyListeners();

      return {'xpGained': xpGained, 'levelUpResult': levelUpResult};
    }
    return {'xpGained': 0, 'levelUpResult': null};
  }

  Future<void> resetStreak(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        currentStreak: 0,
        lastUpdated: DateTime.now(),
      );

      // Mettre à jour dans les objectifs actifs si présent
      final activeIndex = _activeGoals.indexWhere((g) => g.id == goalId);
      if (activeIndex != -1) {
        _activeGoals[activeIndex] = _goals[index];
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

  // Vérifier si tous les objectifs actifs sont terminés
  bool get allActiveGoalsCompleted => _activeGoals.isEmpty;

  // Mettre à jour la priorité d'un objectif
  Future<void> updateGoalPriority(String goalId, int newPriority) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      _goals[index] = _goals[index].copyWith(
        priority: newPriority,
        lastUpdated: DateTime.now(),
      );

      // Mettre à jour dans les objectifs actifs si présent
      final activeIndex = _activeGoals.indexWhere((g) => g.id == goalId);
      if (activeIndex != -1) {
        _activeGoals[activeIndex] = _goals[index];
        _activeGoals.sort((a, b) => a.priority.compareTo(b.priority));
      }

      await _saveGoals();
      notifyListeners();
    }
  }

  // Ajouter un objectif aux objectifs actifs (si possible)
  Future<void> addToActiveGoals(String goalId) async {
    if (_activeGoals.length >= 3) return;

    final goal = _goals.firstWhere(
      (g) => g.id == goalId && g.isActive && !g.isCompleted,
      orElse: () => throw Exception('Objectif introuvable ou non actif'),
    );

    if (!_activeGoals.any((g) => g.id == goalId)) {
      _activeGoals.add(goal);
      _activeGoals.sort((a, b) => a.priority.compareTo(b.priority));
      await _saveGoals();
      notifyListeners();
    }
  }

  // Retirer un objectif des objectifs actifs
  Future<void> removeFromActiveGoals(String goalId) async {
    _activeGoals.removeWhere((g) => g.id == goalId);
    await _saveGoals();
    notifyListeners();
  }
}
