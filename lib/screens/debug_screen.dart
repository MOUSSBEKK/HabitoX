import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../constants/app_colors.dart';
import '../widgets/avatar_widget.dart';
import 'profile_screen.dart';

/// Écran de debug pour tester et simuler la progression utilisateur
/// Permet de modifier facilement les données du profil pour tester l'UI
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug - Test Progression'),
        backgroundColor: AppColors.accentPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Bouton pour naviguer vers ProfileScreen
          IconButton(
            onPressed: () => _navigateToProfile(),
            icon: const Icon(Icons.person),
            tooltip: 'Voir le profil',
          ),
        ],
      ),
      backgroundColor: AppColors.lightBackgroundPrimary,
      body: Consumer<UserProfileService>(
        builder: (context, profileService, child) {
          final stats = profileService.getXpStats();
          final consecutiveDays = stats['consecutiveDays'] as int? ?? 0;
          final accessories = profileService.getUnlockedAvatarAccessories();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // En-tête avec avatar et informations principales
                _buildHeaderCard(consecutiveDays, accessories),

                const SizedBox(height: 16),

                // Carte des données actuelles
                _buildCurrentDataCard(stats),

                const SizedBox(height: 16),

                // Boutons de simulation - Jours consécutifs
                _buildSimulationSection('Simulation Jours Consécutifs', [
                  _buildActionButton(
                    'Ajouter 1 jour',
                    Icons.add_circle,
                    () => _addConsecutiveDays(1),
                  ),
                  _buildActionButton(
                    'Ajouter 5 jours',
                    Icons.add_circle_outline,
                    () => _addConsecutiveDays(5),
                  ),
                  _buildActionButton(
                    'Reset jours',
                    Icons.refresh,
                    () => _resetConsecutiveDays(),
                    isDestructive: true,
                  ),
                ]),

                const SizedBox(height: 16),

                // Boutons de simulation - XP
                _buildSimulationSection('Simulation XP', [
                  _buildActionButton(
                    'Ajouter 10 XP',
                    Icons.trending_up,
                    () => _addExperience(10),
                  ),
                  _buildActionButton(
                    'Ajouter 100 XP',
                    Icons.trending_up,
                    () => _addExperience(100),
                  ),
                  _buildActionButton(
                    'Reset XP',
                    Icons.refresh,
                    () => _resetExperience(),
                    isDestructive: true,
                  ),
                ]),

                const SizedBox(height: 16),

                // Boutons de simulation - Actions complètes
                _buildSimulationSection('Actions Complètes', [
                  _buildActionButton(
                    'Compléter un objectif',
                    Icons.check_circle,
                    () => _completeGoal(),
                  ),
                  _buildActionButton(
                    'Reset complet',
                    Icons.delete_forever,
                    () => _resetCompleteProfile(),
                    isDestructive: true,
                  ),
                ]),

                const SizedBox(height: 16),

                // Informations sur les accessoires
                _buildAccessoriesInfoCard(accessories),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construit l'en-tête avec avatar et informations principales
  Widget _buildHeaderCard(int consecutiveDays, List<String> accessories) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar avec accessoires
            AnimatedAvatarWidget(
              consecutiveDays: consecutiveDays,
              size: 100,
              backgroundColor: AppColors.accentPrimary.withOpacity(0.1),
              iconColor: AppColors.accentPrimary,
              seed: 'debug_seed',
            ),

            const SizedBox(height: 16),

            // Informations principales
            Text(
              'Avatar de Test',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '$consecutiveDays jours consécutifs',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.darkColor.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '${accessories.length} accessoires débloqués',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit la carte des données actuelles
  Widget _buildCurrentDataCard(Map<String, dynamic> stats) {
    final level = stats['currentLevel'] as int? ?? 1;
    final levelName = stats['levelName'] as String? ?? 'Débutant';
    final levelColor = stats['levelColor'] as Color? ?? AppColors.primaryColor;
    final experiencePoints = stats['experiencePoints'] as int? ?? 0;
    final xpInCurrentLevel = stats['xpInCurrentLevel'] as int? ?? 0;
    final xpRequiredForCurrentLevel =
        stats['xpRequiredForCurrentLevel'] as int? ?? 10;
    final xpProgressToNext = stats['xpProgressToNext'] as double? ?? 0.0;
    final consecutiveDays = stats['consecutiveDays'] as int? ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Données Actuelles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),

            const SizedBox(height: 16),

            // Niveau et nom
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Niveau $level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  levelName,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // XP total
            _buildDataRow('XP Total', '$experiencePoints XP'),

            // XP dans le niveau actuel
            _buildDataRow(
              'XP dans le niveau',
              '$xpInCurrentLevel / $xpRequiredForCurrentLevel XP',
            ),

            // Progression vers le prochain niveau
            _buildDataRow(
              'Progression',
              '${(xpProgressToNext * 100).toStringAsFixed(1)}%',
            ),

            // Jours consécutifs
            _buildDataRow('Jours consécutifs', '$consecutiveDays jours'),
          ],
        ),
      ),
    );
  }

  /// Construit une ligne de données
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkColor.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit une section de simulation avec titre et boutons
  Widget _buildSimulationSection(String title, List<Widget> buttons) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),

            const SizedBox(height: 16),

            // Boutons en grille
            Wrap(spacing: 12, runSpacing: 12, children: buttons),
          ],
        ),
      ),
    );
  }

  /// Construit un bouton d'action
  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDestructive
            ? Colors.red[600]
            : AppColors.accentPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Construit la carte d'informations sur les accessoires
  Widget _buildAccessoriesInfoCard(List<String> accessories) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accessoires Débloqués',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkColor,
              ),
            ),

            const SizedBox(height: 12),

            if (accessories.isEmpty)
              Text(
                'Aucun accessoire débloqué',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkColor.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: accessories
                    .map(
                      (accessory) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.accentPrimary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _getAccessoryDisplayName(accessory),
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.accentPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  /// Obtient le nom d'affichage d'un accessoire
  String _getAccessoryDisplayName(String accessory) {
    switch (accessory) {
      case 'hat':
        return 'Chapeau';
      case 'glasses':
        return 'Lunettes';
      case 'star':
        return 'Étoile';
      case 'crown':
        return 'Couronne';
      case 'wings':
        return 'Ailes';
      case 'halo':
        return 'Halo';
      case 'rainbow':
        return 'Arc-en-ciel';
      case 'fire':
        return 'Feu';
      case 'ice':
        return 'Glace';
      case 'lightning':
        return 'Éclair';
      default:
        return 'Inconnu';
    }
  }

  // ============ MÉTHODES D'ACTION ============

  /// Ajoute des jours consécutifs
  Future<void> _addConsecutiveDays(int days) async {
    final profileService = Provider.of<UserProfileService>(
      context,
      listen: false,
    );

    try {
      // Simuler l'ajout de jours consécutifs
      for (int i = 0; i < days; i++) {
        await profileService.addDayCompleted();
      }

      _showSuccessMessage('Ajouté $days jour(s) consécutif(s)');
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'ajout des jours: $e');
    }
  }

  /// Reset les jours consécutifs
  Future<void> _resetConsecutiveDays() async {
    final confirmed = await _showConfirmationDialog(
      'Reset des jours consécutifs',
      'Êtes-vous sûr de vouloir remettre à zéro les jours consécutifs ?',
    );

    if (confirmed) {
      final profileService = Provider.of<UserProfileService>(
        context,
        listen: false,
      );

      try {
        // Créer un nouveau profil avec les jours consécutifs à 0
        final currentProfile = profileService.userProfile;
        if (currentProfile != null) {
          final newProfile = currentProfile.copyWith(
            consecutiveDays: 0,
            maxConsecutiveDays: 0,
          );

          // Sauvegarder le nouveau profil
          await profileService.updateProfile(newProfile);

          _showSuccessMessage('Jours consécutifs remis à zéro');
        }
      } catch (e) {
        _showErrorMessage('Erreur lors du reset: $e');
      }
    }
  }

  /// Ajoute de l'expérience
  Future<void> _addExperience(int xp) async {
    final profileService = Provider.of<UserProfileService>(
      context,
      listen: false,
    );

    try {
      final result = await profileService.addExperience(xp);

      String message = 'Ajouté $xp XP';
      if (result.hasLeveledUp) {
        message += ' - Level Up ! Niveau ${result.newLevel}';
      }

      _showSuccessMessage(message);
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'ajout d\'XP: $e');
    }
  }

  /// Reset l'expérience
  Future<void> _resetExperience() async {
    final confirmed = await _showConfirmationDialog(
      'Reset de l\'expérience',
      'Êtes-vous sûr de vouloir remettre à zéro l\'expérience ?',
    );

    if (confirmed) {
      final profileService = Provider.of<UserProfileService>(
        context,
        listen: false,
      );

      try {
        // Créer un nouveau profil avec l'XP à 0
        final currentProfile = profileService.userProfile;
        if (currentProfile != null) {
          final newProfile = currentProfile.copyWith(
            experiencePoints: 0,
            currentLevel: 1,
            totalCompletedGoals: 0,
          );

          // Sauvegarder le nouveau profil
          await profileService.updateProfile(newProfile);

          _showSuccessMessage('Expérience remise à zéro');
        }
      } catch (e) {
        _showErrorMessage('Erreur lors du reset: $e');
      }
    }
  }

  /// Simule la completion d'un objectif
  Future<void> _completeGoal() async {
    final profileService = Provider.of<UserProfileService>(
      context,
      listen: false,
    );

    try {
      // Simuler un objectif de 7 jours
      final result = await profileService.onGoalCompletedXP(7);

      String message = 'Objectif complété ! +7 XP';
      if (result.hasLeveledUp) {
        message += ' - Level Up ! Niveau ${result.newLevel}';
      }

      _showSuccessMessage(message);
    } catch (e) {
      _showErrorMessage('Erreur lors de la completion: $e');
    }
  }

  /// Reset complet du profil
  Future<void> _resetCompleteProfile() async {
    final confirmed = await _showConfirmationDialog(
      'Reset complet',
      'Êtes-vous sûr de vouloir remettre à zéro TOUT le profil ? Cette action est irréversible.',
    );

    if (confirmed) {
      final profileService = Provider.of<UserProfileService>(
        context,
        listen: false,
      );

      try {
        await profileService.resetProfile();
        _showSuccessMessage('Profil complètement remis à zéro');
      } catch (e) {
        _showErrorMessage('Erreur lors du reset complet: $e');
      }
    }
  }

  /// Navigue vers l'écran de profil
  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  // ============ MÉTHODES UTILITAIRES ============

  /// Affiche un message de succès
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Affiche un message d'erreur
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Affiche un dialogue de confirmation
  Future<bool> _showConfirmationDialog(String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
