import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserProfileService extends ChangeNotifier {
  static const String _profileKey = 'userProfile';
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;
  bool get hasProfile => _userProfile != null;

  UserProfileService() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);

    if (profileJson != null) {
      _userProfile = UserProfile.fromJson(jsonDecode(profileJson));
    } else {
      // Créer un profil par défaut
      _userProfile = UserProfile(
        id: _generateId(),
        username: 'HabitoX_User',
        lastActivityDate: DateTime.now(),
        createdAt: DateTime.now(),
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

  Future<void> updateUsername(String newUsername) async {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(username: newUsername);
      await _saveProfile();
      notifyListeners();
    }
  }

  // Méthode pour vérifier le statut premium
  bool get isPremium => _userProfile?.isPremium ?? false;

  // Méthode pour activer le premium (pour les tests ou l'achat)
  Future<void> setPremiumStatus(bool isPremium) async {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(isPremium: isPremium);
      await _saveProfile();
      notifyListeners();
    }
  }

  // Méthode de test pour basculer le statut premium (à supprimer en production)
  Future<void> togglePremiumStatus() async {
    if (_userProfile != null) {
      await setPremiumStatus(!_userProfile!.isPremium);
    }
  }

  // Méthode appelée quand un objectif est terminé (ancien système)
  // Future<void> onGoalCompleted() async {
  //   if (_userProfile != null) {
  //     _userProfile!.onGoalCompleted();
  //     await _saveProfile();
  //     notifyListeners();
  //   }
  // }

  // Nouvelle méthode pour ajouter de l'XP
  Future<LevelUpResult?> addExperience(
    int xp, {
    bool isConsistencyBonus = false,
  }) async {
    if (_userProfile != null) {
      final result = _userProfile!.addExperience(
        xp,
        isConsistencyBonus: isConsistencyBonus,
      );
      await _saveProfile();
      notifyListeners();
      return result;
    }
    return null;
  }

  // Méthode pour completion d'objectif avec nouveau système XP
  Future<LevelUpResult?> onGoalCompletedXP(
    int targetDays, {
    bool completedEarly = false,
  }) async {
    if (_userProfile != null) {
      final xp = UserProfile.calculateGoalXp(
        targetDays,
        completedEarly: completedEarly,
      );
      _userProfile!.totalCompletedGoals++;

      final result = _userProfile!.addExperience(
        xp,
        isConsistencyBonus: completedEarly,
      );
      await _saveProfile();
      notifyListeners();
      return result;
    }
    return null;
  }

  Future<void> resetProfile() async {
    _userProfile = UserProfile(
      id: _generateId(),
      username: 'HabitoX_User',
      lastActivityDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
    await _saveProfile();
    notifyListeners();
  }

  // Nouvelles statistiques XP
  Map<String, dynamic> getXpStats() {
    if (_userProfile == null) return {};

    return {
      'currentLevel': _userProfile!.currentLevel,
      'experiencePoints': _userProfile!.experiencePoints,
      'xpProgressToNext': _userProfile!.xpProgressToNextLevel,
      'xpNeededForNext': _userProfile!.xpNeededForNextLevel,
      'xpInCurrentLevel': _userProfile!.xpInCurrentLevel,
      'xpRequiredForCurrentLevel': _userProfile!.xpRequiredForCurrentLevel,
      'levelName': _userProfile!.levelName,
      'levelColor': _userProfile!.levelColor,
      'totalCompletedGoals': _userProfile!.totalCompletedGoals,
      // 'badgesCount': _userProfile!.unlockedBadges.length,
      // 'specialBadgesCount': _userProfile!.specialBadges.length,
    };
  }

  // Obtenir les badges débloqués
  // List<AuraBadge> get unlockedBadges {
  //   return _userProfile?.unlockedBadges ?? [];
  // }

  // Vérifier si un nouveau badge a été débloqué
  // bool get hasNewBadge {
  //   if (_userProfile == null) return false;

  //   final lastBadge = _userProfile!.unlockedBadges.isNotEmpty
  //       ? _userProfile!.unlockedBadges.last
  //       : null;

  //   if (lastBadge != null) {
  //     final timeSinceUnlock = DateTime.now().difference(lastBadge.unlockedAt);
  //     return timeSinceUnlock.inMinutes <
  //         5; // Nouveau si débloqué il y a moins de 5 minutes
  //   }

  //   return false;
  // }

  // Obtenir les points nécessaires pour le prochain niveau
  // int get pointsNeededForNextLevel {
  //   final currentLevel = _userProfile?.auraLevel ?? 1;
  //   final nextLevelPoints = pow(currentLevel * 100, 2).toInt();
  //   final currentPoints = _userProfile?.auraPoints ?? 0;
  //   return nextLevelPoints - currentPoints;
  // }

  String _generateId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'profile_$random';
  }
}
