import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';
import '../models/user_profile.dart';
import 'user_profile_service.dart';
import 'home_widget_service.dart';

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
    List<dynamic> rawGoalsList = [];
    String? activeGoalId = localStorage.getItem(_activeGoalKey);

    if (storedGoalsJson != null) {
      try {
        final decoded = jsonDecode(storedGoalsJson);
        if (decoded is List) {
          rawGoalsList = decoded;
        }
      } catch (_) {
        rawGoalsList = [];
      }
    } else {
      // 2) Migration depuis SharedPreferences (ancienne version)
      try {
        final prefs = await SharedPreferences.getInstance();
        final goalsJsonList = prefs.getStringList(_goalsKey) ?? [];
        rawGoalsList = goalsJsonList.map((json) => jsonDecode(json)).toList();
        activeGoalId = prefs.getString(_activeGoalKey);

        // Sauvegarder dans localstorage au nouveau format (liste de maps)
        localStorage.setItem(_goalsKey, jsonEncode(rawGoalsList));
        if (activeGoalId != null) {
          localStorage.setItem(_activeGoalKey, activeGoalId);
        }
      } catch (_) {
        rawGoalsList = [];
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
    await initLocalStorage();
    final goalsList = _goals.map((goal) => goal.toJson()).toList();
    localStorage.setItem(_goalsKey, jsonEncode(goalsList));
    if (_activeGoal != null) {
      localStorage.setItem(_activeGoalKey, _activeGoal!.id);
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

  Future<void> updateGoal(Goal goal, [BuildContext? context]) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;

      // Si c'est l'objectif actif, on le met à jour
      if (_activeGoal?.id == goal.id) {
        _activeGoal = goal;
      }

      await _saveGoals();
      notifyListeners();

      // Mettre à jour le widget si c'est l'objectif actif
      if (_activeGoal?.id == goal.id && context != null) {
        await HomeWidgetService.updateActiveGoalHeatmap(context, this);
      }
    }
  }

  Future<void> deleteGoal(String goalId, [BuildContext? context]) async {
    final wasActiveGoal = _activeGoal?.id == goalId;

    _goals.removeWhere((goal) => goal.id == goalId);

    // Si on supprime l'objectif actif, on en sélectionne un autre
    if (_activeGoal?.id == goalId) {
      _activeGoal = _goals.isNotEmpty ? _goals.first : null;
    }

    await _saveGoals();
    notifyListeners();

    // Mettre à jour le widget si on a supprimé l'objectif actif
    if (wasActiveGoal && context != null) {
      await HomeWidgetService.updateActiveGoalHeatmap(context, this);
    }
  }

  Future<void> activateGoal(String goalId, [BuildContext? context]) async {
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

      // Mettre à jour le widget avec le nouvel objectif actif
      if (context != null) {
        await HomeWidgetService.updateActiveGoalHeatmap(context, this);
      }
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

      // Si c'était l'objectif actif, on le retire
      if (_activeGoal?.id == goalId) {
        _activeGoal = null;
      }

      // Notifier le profil utilisateur qu'un objectif a été terminé
      // if (profileService != null) {
      //   await profileService.onGoalCompleted();
      // }

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

        // Si c'est l'objectif actif, on met aussi à jour sa référence
        if (_activeGoal?.id == goal.id) {
          _activeGoal = _goals[index];
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

      // Si c'était l'objectif actif, on le retire
      if (_activeGoal?.id == goalId) {
        _activeGoal = null;
      }

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

  // Méthodes pour les données d'analytics
  List<FlSpot> getDailyCompletionsData(int timeRange) {
    final now = DateTime.now();
    DateTime startDate;

    switch (timeRange) {
      case 0: // Week
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 1: // Month
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 2: // Lifetime
        startDate = DateTime(
          2020,
        ); // Date très ancienne pour capturer toutes les données
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    // Récupérer toutes les sessions complétées dans la période
    final allSessions = <DateTime>[];
    for (final goal in _goals) {
      allSessions.addAll(
        goal.completedSessions.where(
          (session) =>
              session.isAfter(startDate) &&
              session.isBefore(now.add(const Duration(days: 1))),
        ),
      );
    }

    // Grouper par jour
    final Map<String, int> dailyCompletions = {};
    for (final session in allSessions) {
      final dayKey =
          '${session.year}-${session.month.toString().padLeft(2, '0')}-${session.day.toString().padLeft(2, '0')}';
      dailyCompletions[dayKey] = (dailyCompletions[dayKey] ?? 0) + 1;
    }

    // Créer les points pour le graphique
    final List<FlSpot> spots = [];
    if (timeRange == 0) {
      // Pour la semaine, on affiche les 7 derniers jours
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        spots.add(
          FlSpot(
            6 - i.toDouble(),
            ((dailyCompletions[dayKey]) ?? 0).toDouble(),
          ),
        );
      }
    } else if (timeRange == 1) {
      // Pour le mois, on groupe par semaine (4 semaines)
      final Map<int, int> weeklyCompletions = {};
      for (int i = 0; i < 4; i++) {
        final weekStart = now.subtract(Duration(days: (i + 1) * 7));
        final weekEnd = now.subtract(Duration(days: i * 7));
        weeklyCompletions[i] = 0;

        for (final session in allSessions) {
          if (session.isAfter(weekStart) && session.isBefore(weekEnd)) {
            weeklyCompletions[i] = weeklyCompletions[i]! + 1;
          }
        }
      }

      for (int i = 0; i < 4; i++) {
        spots.add(FlSpot(i.toDouble(), weeklyCompletions[i]!.toDouble()));
      }
    } else {
      // Pour lifetime, on groupe par mois (12 derniers mois)
      final Map<int, int> monthlyCompletions = {};
      for (int i = 0; i < 12; i++) {
        final monthStart = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 1);
        monthlyCompletions[i] = 0;

        for (final session in allSessions) {
          if (session.isAfter(monthStart) && session.isBefore(monthEnd)) {
            monthlyCompletions[i] = monthlyCompletions[i]! + 1;
          }
        }
      }

      for (int i = 0; i < 12; i++) {
        spots.add(FlSpot(i.toDouble(), monthlyCompletions[i]!.toDouble()));
      }
    }
    debugPrint('spots: $spots');
    return spots;
  }

  List<String> getChartLabels(int timeRange) {
    final now = DateTime.now();

    switch (timeRange) {
      case 0: // Week
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 1: // Month
        return ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'];
      case 2: // Lifetime
        final labels = <String>[];
        for (int i = 11; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i, 1);
          labels.add('${date.month}/${date.year}');
        }
        return labels;
      default:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    }
  }

  Map<String, int> getMarkingsVsMissesData(int timeRange) {
    final now = DateTime.now();
    DateTime startDate;

    switch (timeRange) {
      case 0: // Week
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 1: // Month
        startDate = now.subtract(const Duration(days: 30));
        break;
      case 2: // Lifetime
        startDate = DateTime(2020);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    int totalMarkings = 0;
    int totalMisses = 0;

    for (final goal in _goals) {
      // Compter les marquages dans la période
      final markingsInPeriod = goal.completedSessions
          .where(
            (session) =>
                session.isAfter(startDate) &&
                session.isBefore(now.add(const Duration(days: 1))),
          )
          .length;
      totalMarkings += markingsInPeriod;

      // Calculer les oublis (jours où l'objectif était actif mais pas marqué)
      if (goal.isActive || goal.isCompleted) {
        final goalStartDate = goal.createdAt.isAfter(startDate)
            ? goal.createdAt
            : startDate;
        final goalEndDate = goal.isCompleted && goal.completedAt != null
            ? goal.completedAt!.isBefore(now)
                  ? goal.completedAt!
                  : now
            : now;

        final totalDaysInPeriod =
            goalEndDate.difference(goalStartDate).inDays + 1;
        final expectedMarkings = totalDaysInPeriod;
        final actualMisses = expectedMarkings - markingsInPeriod;
        totalMisses += actualMisses > 0 ? actualMisses : 0;
      }
    }

    return {'markings': totalMarkings, 'misses': totalMisses};
  }

  int getArchivedGoalsCount() {
    return archivedGoals.length;
  }
}
