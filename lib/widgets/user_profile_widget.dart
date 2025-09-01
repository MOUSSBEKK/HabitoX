import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget>
    with TickerProviderStateMixin {
  late AnimationController _auraController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _auraAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  bool _isEditingUsername = false;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _auraController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _auraAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _auraController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Démarrer les animations
    _startAnimations();
  }

  void _startAnimations() {
    _auraController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _auraController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Méthode pour obtenir le chemin du badge selon le niveau
  String _getBadgeAssetForLevel(int level) {
    final List<String> assetFiles = [
      'BADGE1.png',
      'BADGE2.png',
      'BADGE3.png',
      'BADGE4.png',
      'BADGE5.png',
      'BADGE6.png',
      'BADGE7.png',
      'BADGE8.png',
      'BADGE9.png',
      'BADGE10.png',
    ];
    final index = (level - 1).clamp(0, assetFiles.length - 1);
    return 'assets/badges/${assetFiles[index]}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileService>(
      builder: (context, profileService, child) {
        final profile = profileService.userProfile;

        // If profile is null, show a loading or error state
        if (profile == null) {
          return Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Chargement du profil...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Utiliser le nouveau système XP
        final stats = profileService.getXpStats();

        // Ensure stats has all required values with defaults
        final levelColor = stats['levelColor'] as Color? ?? Colors.grey;

        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  levelColor.withValues(alpha: 0.1),
                  levelColor.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildProfileHeader(profile, stats),
                  const SizedBox(height: 24),
                  _buildXpBar(profileService, stats),
                  const SizedBox(height: 24),
                  _buildXpStats(profile, stats),
                  const SizedBox(height: 24),
                  _buildActions(profileService),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserProfile profile, Map<String, dynamic> stats) {
    // Get safe values from stats
    final levelColor = stats['levelColor'] as Color? ?? Colors.grey;

    return Row(
      children: [
        // Badge actuel avec effet de pulsation
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final badgeAsset = _getBadgeAssetForLevel(profile.currentLevel);
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      levelColor.withValues(alpha: 0.3),
                      levelColor.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: levelColor.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      badgeAsset,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: levelColor.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.workspace_premium,
                            size: 40,
                            color: levelColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom d'utilisateur éditable
              if (_isEditingUsername) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        autofocus: true,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _saveUsername(),
                      icon: const Icon(Icons.check, color: Colors.green),
                    ),
                    IconButton(
                      onPressed: () => _cancelUsernameEdit(),
                      icon: const Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        profile.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _startUsernameEdit(),
                      icon: Icon(Icons.edit, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),

              // Niveau utilisateur
              Row(
                children: [
                  Text(
                    stats['levelName'] ?? 'Débutant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: levelColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: levelColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: levelColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Niveau ${stats['currentLevel']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: levelColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildXpBar(
    UserProfileService profileService,
    Map<String, dynamic> stats,
  ) {
    // Get safe values from stats
    final levelColor = stats['levelColor'] as Color? ?? Colors.grey;
    final xpProgressToNext = stats['xpProgressToNext'] as double? ?? 0.0;
    final xpInCurrentLevel = stats['xpInCurrentLevel'] as int? ?? 0;
    final xpRequiredForCurrentLevel = stats['xpRequiredForCurrentLevel'] as int? ?? 10;
    final currentLevel = stats['currentLevel'] as int? ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression XP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$xpInCurrentLevel / $xpRequiredForCurrentLevel XP',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: levelColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Barre XP animée
        AnimatedBuilder(
          animation: _auraAnimation,
          builder: (context, child) {
            return Container(
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: levelColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Fond de la barre
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                  ),

                  // Progression XP
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.7 *
                            xpProgressToNext,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              levelColor,
                              levelColor.withValues(alpha: 0.8),
                              levelColor.withValues(alpha: 0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: levelColor.withValues(
                                alpha: 0.5 + _glowAnimation.value * 0.3,
                              ),
                              blurRadius: 15 + _glowAnimation.value * 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: currentLevel < 8 ? Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            '${(xpProgressToNext * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ) : null,
                      );
                    },
                  ),

                  // Effet de particules flottantes XP
                  if (xpProgressToNext > 0) ...List.generate(3, (index) {
                    return Positioned(
                      left:
                          (MediaQuery.of(context).size.width *
                              0.7 *
                              xpProgressToNext *
                              (0.3 + index * 0.2)) %
                          (MediaQuery.of(context).size.width * 0.7),
                      top: 4 + (index % 2) * 6,
                      child: AnimatedBuilder(
                        animation: _auraAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _auraAnimation.value * 3),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        Text(
          currentLevel >= 8 
            ? 'Niveau maximum atteint ! 🎉'
            : 'Progression vers le niveau ${currentLevel + 1}',
          style: TextStyle(
            fontSize: 12, 
            color: currentLevel >= 8 ? levelColor : Colors.grey[600],
            fontWeight: currentLevel >= 8 ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildXpStats(UserProfile profile, Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'XP Total',
            '${stats['experiencePoints']}',
            Icons.star,
            Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Objectifs',
            '${stats['totalCompletedGoals']}',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Badges',
            '${stats['badgesCount']}',
            Icons.workspace_premium,
            Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Spéciaux',
            '${stats['specialBadgesCount']}',
            Icons.military_tech,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(UserProfileService profileService) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showAuraInfo(context),
            icon: const Icon(Icons.info_outline),
            label: const Text('Info Aura'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showResetConfirmation(context, profileService),
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _startUsernameEdit() {
    setState(() {
      _isEditingUsername = true;
      _usernameController.text =
          context.read<UserProfileService>().userProfile?.username ?? '';
    });
  }

  void _saveUsername() {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty) {
      context.read<UserProfileService>().updateUsername(newUsername);
    }
    setState(() {
      _isEditingUsername = false;
    });
  }

  void _cancelUsernameEdit() {
    setState(() {
      _isEditingUsername = false;
    });
  }

  void _showAuraInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Système d\'Aura'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comment fonctionne l\'Aura :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• +100 points d\'aura par jour complété'),
              Text('• +20 bonus pour 3+ jours consécutifs'),
              Text('• +50 bonus pour 7+ jours consécutifs'),
              SizedBox(height: 8),
              Text('⚠️ Perte exponentielle d\'aura :'),
              Text('• 1 jour manqué : -75 points'),
              Text('• 2 jours manqués : -112 points'),
              Text('• 3 jours manqués : -168 points'),
              SizedBox(height: 8),
              Text('🏆 Badges débloqués tous les 5 niveaux'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(
    BuildContext context,
    UserProfileService profileService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset du Profil'),
        content: const Text(
          'Êtes-vous sûr de vouloir réinitialiser votre profil ?\n\n'
          'Cela supprimera toute votre progression d\'aura, vos badges et vos statistiques.\n\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              profileService.resetProfile();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil réinitialisé'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
