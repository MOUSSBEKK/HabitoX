import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'dart:math';

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

  Future<void> addAuraForDay() async {
    if (_userProfile != null) {
      _userProfile!.addAuraForDay();
      await _saveProfile();
      notifyListeners();
    }
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

  // Simuler une perte d'aura (pour les tests)
  Future<void> simulateMissedDay() async {
    if (_userProfile != null) {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      _userProfile = _userProfile!.copyWith(lastActivityDate: yesterday);

      // Ajouter de l'aura pour déclencher la perte
      addAuraForDay();
    }
  }

  // Obtenir les statistiques d'aura
  Map<String, dynamic> getAuraStats() {
    if (_userProfile == null) return {};

    return {
      'currentLevel': _userProfile!.auraLevel,
      'currentPoints': _userProfile!.auraPoints,
      'progressToNext': _userProfile!.progressToNextLevel,
      'levelName': _userProfile!.auraLevelName,
      'auraColor': _userProfile!.auraColor,
      'auraEmoji': _userProfile!.auraEmoji,
      'consecutiveDays': _userProfile!.consecutiveDays,
      'maxConsecutiveDays': _userProfile!.maxConsecutiveDays,
      'totalDaysCompleted': _userProfile!.totalDaysCompleted,
      'badgesCount': _userProfile!.unlockedBadges.length,
    };
  }

  // Obtenir les badges débloqués
  List<AuraBadge> get unlockedBadges {
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

  // Calculer la perte d'aura pour X jours manqués
  int calculateAuraLossForDays(int daysMissed) {
    if (daysMissed <= 0) return 0;
    return (50 * pow(1.5, daysMissed)).round();
  }

  // Obtenir le prochain niveau d'aura
  int get nextAuraLevel {
    return (_userProfile?.auraLevel ?? 1) + 1;
  }

  // Obtenir les points nécessaires pour le prochain niveau
  int get pointsNeededForNextLevel {
    final currentLevel = _userProfile?.auraLevel ?? 1;
    final nextLevelPoints = pow(currentLevel * 100, 2).toInt();
    final currentPoints = _userProfile?.auraPoints ?? 0;
    return nextLevelPoints - currentPoints;
  }

  String _generateId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'profile_$random';
  }
}
