import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';
import '../models/calendar_shape.dart';
import 'user_profile_service.dart';

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

        // Si c'est l'objectif actif, on met aussi à jour sa référence
        if (_activeGoal?.id == goal.id) {
          _activeGoal = _goals[index];
        }

        // Vérifier si l'objectif est complété
        if (newProgress >= 1.0) {
          await completeGoal(goalId);
        } else {
          await _saveGoals();
          notifyListeners();
        }

        // Mettre à jour le profil et vérifier si on a monté de niveau
        // La notification sera gérée par le widget qui appelle cette méthode
      }
    }
  }

  // Méthode pour mettre à jour le profil (appelée depuis l'extérieur)
  Future<bool> updateProfile(UserProfileService profileService) async {
    return await profileService.addDayCompleted();
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

  // Afficher la notification de montée de niveau
  static void showLevelUpNotification(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Text('🎉', style: TextStyle(fontSize: 60)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Félicitations !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Vous avez monté un niveau !',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Continuez comme ça !',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continuer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
