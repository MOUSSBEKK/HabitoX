import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer l'état d'onboarding de l'application HabitoX
/// Gère la détection du premier lancement et la persistance de l'état
class OnboardingService extends ChangeNotifier {
  static const String _firstTimeUserKey = 'isFirstTimeUser';
  bool _isFirstTimeUser = true;
  bool _isLoading = true;

  /// Indique si c'est le premier lancement de l'application
  bool get isFirstTimeUser => _isFirstTimeUser;

  /// Indique si le service est en cours de chargement
  bool get isLoading => _isLoading;

  OnboardingService() {
    _initializeOnboardingState();
  }

  /// Initialise l'état d'onboarding au démarrage de l'application
  Future<void> _initializeOnboardingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Récupère l'état depuis le stockage local
      // Par défaut true si c'est la première fois
      _isFirstTimeUser = prefs.getBool(_firstTimeUserKey) ?? true;
      
      _isLoading = false;
      notifyListeners();
      
      debugPrint('🚀 OnboardingService: Premier utilisateur = $_isFirstTimeUser');
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'initialisation de l\'onboarding: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Marque l'onboarding comme terminé
  /// Cette méthode est appelée quand l'utilisateur termine l'onboarding
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Sauvegarde l'état dans le stockage local
      await prefs.setBool(_firstTimeUserKey, false);
      
      _isFirstTimeUser = false;
      notifyListeners();
      
      debugPrint('✅ OnboardingService: Onboarding terminé et sauvegardé');
    } catch (e) {
      debugPrint('❌ Erreur lors de la sauvegarde de l\'onboarding: $e');
    }
  }

  /// Force le reset de l'onboarding (utile pour les tests)
  /// ⚠️ À utiliser uniquement en développement
  Future<void> resetOnboarding() async {
    if (kDebugMode) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_firstTimeUserKey, true);
        
        _isFirstTimeUser = true;
        notifyListeners();
        
        debugPrint('🔄 OnboardingService: Onboarding réinitialisé');
      } catch (e) {
        debugPrint('❌ Erreur lors du reset de l\'onboarding: $e');
      }
    }
  }

}
