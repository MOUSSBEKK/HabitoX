import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gère la langue de l'application et la persistance du choix utilisateur.
///
/// Valeurs possibles pour [selectedLocaleCode]:
/// - 'system' (par défaut)
/// - 'en', 'fr', 'de', 'es'
class LanguageService extends ChangeNotifier {
  static const String _prefsKey = 'app_language_code';

  LanguageService();

  String _selectedLocaleCode = 'system';

  String get selectedLocaleCode => _selectedLocaleCode;

  /// Retourne la locale effective à utiliser par MaterialApp.
  /// null => laisse Flutter utiliser la locale système.
  Locale? get effectiveLocale {
    if (_selectedLocaleCode == 'system') return null;
    return Locale(_selectedLocaleCode);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLocaleCode = prefs.getString(_prefsKey) ?? 'system';
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (code != 'system' &&
        code != 'en' &&
        code != 'fr' &&
        code != 'de' &&
        code != 'es') {
      return;
    }
    _selectedLocaleCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _selectedLocaleCode);
    notifyListeners();
  }
}
