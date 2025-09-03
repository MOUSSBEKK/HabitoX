import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart' as models;

class UserProfileService extends ChangeNotifier {
  static const String _profileKey = 'userProfile';
  models.UserProfile? _userProfile;

  models.UserProfile? get userProfile => _userProfile;
  bool get hasProfile => _userProfile != null;

  UserProfileService() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);

    if (profileJson != null) {
      _userProfile = models.UserProfile.fromJson(jsonDecode(profileJson));
      // S'assurer que l'utilisateur a au moins le premier badge
      _ensureFirstBadgeUnlocked();
    } else {
      // Créer un profil par défaut sans badges débloqués
      _userProfile = models.UserProfile(
        id: _generateId(),
        username: 'HabitoX_User',
        lastActivityDate: DateTime.now(),
        createdAt: DateTime.now(),
        unlockedBadges: [], // Aucun badge débloqué par défaut
      );
      await _saveProfile();
    }

    notifyListeners();
  }

  Future<void> _saveProfile() async {
    if (_userProfile == null) return;

    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(_userProfile!.toJson());
    await prefs.setString(_profileKey, profileJson);
  }

  // Méthode publique pour sauvegarder le profil (utilisée par DebugScreen)
  Future<void> saveProfile() async {
    await _saveProfile();
  }

  // Méthode pour mettre à jour directement le profil (utilisée par DebugScreen)
  Future<void> updateProfile(models.UserProfile newProfile) async {
    _userProfile = newProfile;
    await _saveProfile();
    notifyListeners();
  }

  Future<void> updateUsername(String newUsername) async {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(username: newUsername);
      await _saveProfile();
      notifyListeners();
    }
  }

  Future<bool> addDayCompleted() async {
    if (_userProfile != null) {
      final oldLevel = _userProfile!.currentLevel;
      _userProfile!.addAuraForDay();
      await _saveProfile();
      notifyListeners();
      return _userProfile!.currentLevel > oldLevel;
    }
    return false;
  }

  Future<void> resetProfile() async {
    _userProfile = models.UserProfile(
      id: _generateId(),
      username: 'HabitoX_User',
      lastActivityDate: DateTime.now(),
      createdAt: DateTime.now(),
      unlockedBadges: [], // Aucun badge débloqué par défaut
    );
    await _saveProfile();
    notifyListeners();
  }

  // Obtenir les statistiques du profil (ancien système)
  Map<String, dynamic> getProfileStats() {
    if (_userProfile == null) return {};

    return {
      'currentLevel': _userProfile!.auraLevel,
      'progressToNext': _userProfile!.progressToNextLevel,
      'levelName': _userProfile!.auraLevelName,
      'levelColor': _userProfile!.auraColor,
      'levelEmoji': _userProfile!.auraEmoji,
      'consecutiveDays': _userProfile!.consecutiveDays,
      'maxConsecutiveDays': _userProfile!.maxConsecutiveDays,
      'totalDaysCompleted': _userProfile!.totalDaysCompleted,
      'badgesCount': _userProfile!.unlockedBadges.length,
    };
  }

  // Obtenir les statistiques XP (nouveau système)
  Map<String, dynamic> getXpStats() {
    if (_userProfile == null) return {};

    return {
      'currentLevel': _userProfile!.currentLevel,
      'levelName': _userProfile!.levelName,
      'levelColor': _userProfile!.levelColor,
      'experiencePoints': _userProfile!.experiencePoints,
      'xpInCurrentLevel': _userProfile!.xpInCurrentLevel,
      'xpRequiredForCurrentLevel': _userProfile!.xpRequiredForCurrentLevel,
      'xpProgressToNext': _userProfile!.xpProgressToNextLevel,
      'consecutiveDays': _userProfile!.consecutiveDays,
      'maxConsecutiveDays': _userProfile!.maxConsecutiveDays,
      'totalDaysCompleted': _userProfile!.totalDaysCompleted,
      'badgesCount': _userProfile!.unlockedBadges.length,
    };
  }

  // Obtenir les badges débloqués
  List<models.AuraBadge> get unlockedBadges {
    return _userProfile?.unlockedBadges ?? [];
  }

  // Vérifier si un nouveau badge a été débloqué
  bool get hasNewBadge {
    if (_userProfile == null) return false;

    final lastBadge = _userProfile!.unlockedBadges.isNotEmpty
        ? _userProfile!.unlockedBadges.last
        : null;

    if (lastBadge != null) {
      final timeSinceUnlock = DateTime.now().difference(lastBadge.unlockedAt);
      return timeSinceUnlock.inMinutes <
          5; // Nouveau si débloqué il y a moins de 5 minutes
    }

    return false;
  }

  // Obtenir le prochain niveau
  int get nextLevel {
    return (_userProfile?.currentLevel ?? 1) + 1;
  }

  // Obtenir les jours nécessaires pour le prochain niveau
  int get daysNeededForNextLevel {
    // Avec le nouveau système, il faut 1 jour complété pour monter de niveau
    return 1;
  }

  // S'assurer que l'utilisateur a au moins le premier badge
  void _ensureFirstBadgeUnlocked() {
    // Ne plus donner de badge par défaut - ils se débloquent selon la progression
  }

  // ============ GESTION DES ACCESSOIRES D'AVATAR ============

  // Obtenir les accessoires débloqués basés sur les jours consécutifs
  List<String> getUnlockedAvatarAccessories() {
    if (_userProfile == null) return [];

    final consecutiveDays = _userProfile!.consecutiveDays;
    final accessories = <String>[];

    // Débloquer un accessoire tous les 5 jours consécutifs
    for (int i = 5; i <= consecutiveDays; i += 5) {
      accessories.add(_getAccessoryForDays(i));
    }

    return accessories;
  }

  // Obtenir l'accessoire correspondant à un nombre de jours
  String _getAccessoryForDays(int days) {
    final accessories = [
      'hat', // 5 jours
      'glasses', // 10 jours
      'star', // 15 jours
      'crown', // 20 jours
      'wings', // 25 jours
      'halo', // 30 jours
      'rainbow', // 35 jours
      'fire', // 40 jours
      'ice', // 45 jours
      'lightning', // 50 jours
    ];

    final index = (days ~/ 5) - 1;
    if (index >= 0 && index < accessories.length) {
      return accessories[index];
    }

    // Pour les jours très élevés, répéter les accessoires
    return accessories[index % accessories.length];
  }

  // Ajouter de l'XP et gérer les accessoires
  Future<models.LevelUpResult> addExperience(
    int xp, {
    bool isConsistencyBonus = false,
  }) async {
    if (_userProfile == null) {
      throw Exception('Profil utilisateur non initialisé');
    }

    final result = _userProfile!.addExperience(
      xp,
      isConsistencyBonus: isConsistencyBonus,
    );
    await _saveProfile();
    notifyListeners();
    return result;
  }

  // Méthode pour gérer la completion d'un objectif (ancien système)
  Future<void> onGoalCompleted() async {
    if (_userProfile != null) {
      _userProfile!.onGoalCompleted();
      await _saveProfile();
      notifyListeners();
    }
  }

  // Méthode pour gérer la completion d'un objectif avec XP (nouveau système)
  Future<models.LevelUpResult> onGoalCompletedXP(
    int xp, {
    bool isConsistencyBonus = false,
  }) async {
    if (_userProfile == null) {
      throw Exception('Profil utilisateur non initialisé');
    }

    // Ajouter l'XP pour la completion de l'objectif
    final result = _userProfile!.addExperience(
      xp,
      isConsistencyBonus: isConsistencyBonus,
    );

    // Incrémenter le compteur d'objectifs complétés
    _userProfile = _userProfile!.copyWith(
      totalCompletedGoals: _userProfile!.totalCompletedGoals + 1,
    );

    await _saveProfile();
    notifyListeners();
    return result;
  }

  String _generateId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'profile_$random';
  }
}
