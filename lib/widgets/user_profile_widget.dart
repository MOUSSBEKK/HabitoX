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
  late AnimationController _levelController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _levelAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  bool _isEditingUsername = false;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _levelController = AnimationController(
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

    _levelAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _levelController, curve: Curves.easeInOut),
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
    _levelController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _levelController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _usernameController.dispose();
    super.dispose();
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

        final stats = profileService.getProfileStats();

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
                  _buildLevelBar(profileService, stats),
                  const SizedBox(height: 24),
                  _buildProfileStats(profile, stats),
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
    final levelEmoji = stats['levelEmoji'] as String? ?? '💎';

    return Row(
      children: [
        // Avatar avec effet de pulsation
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      levelColor,
                      levelColor.withValues(alpha: 0.7),
                      levelColor.withValues(alpha: 0.3),
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
                child: Center(
                  child: Text(levelEmoji, style: const TextStyle(fontSize: 40)),
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

              // Niveau avec badges
              Row(
                children: [
                  Text(
                    stats['levelName'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: stats['levelColor'],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: stats['levelColor'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: stats['levelColor'].withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Niveau ${stats['currentLevel']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: stats['levelColor'],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Afficher les badges gagnés
                  _buildBadgesDisplay(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBar(
    UserProfileService profileService,
    Map<String, dynamic> stats,
  ) {
    // Get safe values from stats
    final levelColor = stats['levelColor'] as Color? ?? Colors.grey;
    final progressToNext = stats['progressToNext'] as double? ?? 0.0;
    final currentLevel = stats['currentLevel'] as int? ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'Niveau $currentLevel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: levelColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Barre de progression animée
        AnimatedBuilder(
          animation: _levelAnimation,
          builder: (context, child) {
            return Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                  ),

                  // Progression du niveau
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width:
                            MediaQuery.of(context).size.width *
                            0.7 *
                            progressToNext,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                      );
                    },
                  ),

                  // Effet de particules flottantes
                  ...List.generate(5, (index) {
                    return Positioned(
                      left:
                          (MediaQuery.of(context).size.width *
                              0.7 *
                              progressToNext *
                              (0.2 + index * 0.15)) %
                          (MediaQuery.of(context).size.width * 0.7),
                      top: 2 + (index % 2) * 8,
                      child: AnimatedBuilder(
                        animation: _levelAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _levelAnimation.value * 4),
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
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
          'Prochain niveau: ${currentLevel + 1}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildProfileStats(UserProfile profile, Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Jours consécutifs',
            '${stats['consecutiveDays']}',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Meilleure série',
            '${stats['maxConsecutiveDays']}',
            Icons.emoji_events,
            Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total jours',
            '${stats['totalDaysCompleted']}',
            Icons.calendar_today,
            Colors.blue,
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

  Widget _buildBadgesDisplay() {
    final profile = context.read<UserProfileService>().userProfile;
    if (profile == null || profile.unlockedBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    // Afficher le badge le plus récent (le dernier débloqué)
    final latestBadge = profile.unlockedBadges.last;

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: latestBadge.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: latestBadge.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(latestBadge.emoji, style: const TextStyle(fontSize: 18)),
    );
  }

  Widget _buildActions(UserProfileService profileService) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showLevelInfo(context),
            icon: const Icon(Icons.info_outline),
            label: const Text('Info Niveaux'),
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

  void _showLevelInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Système de Niveaux'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comment fonctionne le système de niveaux :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• 1 jour complété = 1 niveau'),
              Text('• Commence au niveau 1'),
              Text('• Passe au niveau 2 après la première session'),
              SizedBox(height: 8),
              Text('🏆 Badges débloqués :'),
              Text('• Badge 1: Niveau 2 (1 jour)'),
              Text('• Badge 2: Niveau 5 (4 jours)'),
              Text('• Badge 3: Niveau 10 (9 jours)'),
              Text('• Badge 4: Niveau 20 (19 jours)'),
              Text('• Et ainsi de suite...'),
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
          'Cela supprimera toute votre progression, vos badges et vos statistiques.\n\n'
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
