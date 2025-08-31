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

  Future<void> updateUsername(String newUsername) async {
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(username: newUsername);
      await _saveProfile();
      notifyListeners();
    }
  }

  Future<bool> addDayCompleted() async {
    if (_userProfile != null) {
      final leveledUp = _userProfile!.addDayCompleted();
      await _saveProfile();
      notifyListeners();
      return leveledUp;
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

  // Obtenir les statistiques du profil
  Map<String, dynamic> getProfileStats() {
    if (_userProfile == null) return {};

    return {
      'currentLevel': _userProfile!.level,
      'progressToNext': _userProfile!.progressToNextLevel,
      'levelName': _userProfile!.levelName,
      'levelColor': _userProfile!.levelColor,
      'levelEmoji': _userProfile!.levelEmoji,
      'consecutiveDays': _userProfile!.consecutiveDays,
      'maxConsecutiveDays': _userProfile!.maxConsecutiveDays,
      'totalDaysCompleted': _userProfile!.totalDaysCompleted,
      'badgesCount': _userProfile!.unlockedBadges.length,
    };
  }

  // Obtenir les badges débloqués
  List<models.Badge> get unlockedBadges {
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
    return (_userProfile?.level ?? 1) + 1;
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

  String _generateId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return 'profile_$random';
  }
}
