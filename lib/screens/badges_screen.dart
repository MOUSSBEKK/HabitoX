import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';

// Couleurs du design épuré
class BadgesScreenColors {
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte
}

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;
        // final headerPadding = isTablet ? 80.0 : 60.0;

        return Scaffold(
          appBar: AppBar(title: Text('Achievements')),
          body: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(226, 239, 243, 1),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 24.0 : 20.0),
                  // Dernier badge débloqué (grand)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 24.0 : 20.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: BadgesScreenColors.darkColor.withValues(
                            alpha: 0.06,
                          ),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Consumer<UserProfileService>(
                      builder: (context, profileService, child) {
                        final level =
                            profileService.userProfile?.currentLevel ?? 1;
                        final assetPath = _getBadgeAssetForLevel(level);
                        final imageSize = isTablet ? 160.0 : 120.0;
                        return Column(
                          children: [
                            SizedBox(
                              height: imageSize,
                              child: Image.asset(
                                assetPath,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      color: Colors.grey[400],
                                      size: imageSize * 0.7,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Level $level',
                              style: TextStyle(
                                fontSize: isTablet ? 20.0 : 16.0,
                                fontWeight: FontWeight.w700,
                                color: BadgesScreenColors.darkColor,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: isTablet ? 24.0 : 20.0),
                  // Liste de badges avec fond de progression
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      child: Consumer<UserProfileService>(
                        builder: (context, profileService, _) {
                          final level =
                              profileService.userProfile?.currentLevel ?? 1;
                          final xp =
                              profileService.userProfile?.experiencePoints ?? 0;

                          final List<int> badgeLevels = [
                            1,
                            4,
                            9,
                            19,
                            29,
                            39,
                            49,
                            59,
                            69,
                          ];

                          return ListView.separated(
                            padding: EdgeInsets.only(
                              bottom: isTablet ? 24.0 : 12.0,
                            ),
                            itemCount: badgeLevels.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: isTablet ? 14.0 : 10.0),
                            itemBuilder: (context, index) {
                              final requiredLevel = badgeLevels[index];
                              final isUnlocked = level >= requiredLevel;
                              final prevLevel = index == 0
                                  ? badgeLevels.first
                                  : badgeLevels[index - 1];

                              final baseXp = UserProfile.getTotalXpForLevel(
                                prevLevel,
                              );
                              final targetXp = UserProfile.getTotalXpForLevel(
                                requiredLevel,
                              );
                              final currentInSegment = (xp - baseXp).clamp(
                                0,
                                targetXp - baseXp,
                              );
                              final denominator = (targetXp - baseXp);
                              final progress = denominator == 0
                                  ? 1.0
                                  : (currentInSegment / denominator)
                                        .toDouble()
                                        .clamp(0.0, 1.0);

                              final data = _badgeDisplayData(requiredLevel);

                              final assetPath = _getBadgeAssetByIndex(
                                index + 1,
                              );

                              return _BadgeProgressTile(
                                name: data.name,
                                description: data.description,
                                assetPath: assetPath,
                                color: data.color,
                                isUnlocked: isUnlocked,
                                progress: isUnlocked ? 1.0 : progress,
                                isTablet: isTablet,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getBadgeAssetForLevel(int level) {
    final List<String> assetFiles = [
      'BADGE1.png',
      'BADGE2.png',
      'BADGE3.png',
      'BADGE4.png',
      'BADGE5.png',
      'BADGE6.png',
      'BADGE8.png',
      'BADGE9.png',
      'BADGE10.png',
    ];
    final index = (level - 1).clamp(0, assetFiles.length - 1);
    return 'assets/badges/${assetFiles[index]}';
  }

  String _getBadgeAssetByIndex(int position) {
    final safe = position.clamp(1, 10);
    return 'assets/badges/BADGE$safe.png';
  }

  _BadgeDisplayData _badgeDisplayData(int level) {
    // Réplique minimale des métadonnées d'icône/couleur des niveaux clés
    if (level == 1) {
      return _BadgeDisplayData(
        name: 'Débutant',
        description: 'Bienvenue dans votre parcours HabitoX !',
        emoji: '💎',
        color: Colors.grey[600]!,
      );
    }
    if (level == 4) {
      return _BadgeDisplayData(
        name: 'Déterminé',
        description: 'Votre détermination commence à porter ses fruits !',
        emoji: '⚡',
        color: Colors.orange[600]!,
      );
    }
    if (level == 9) {
      return _BadgeDisplayData(
        name: 'Elite',
        description: 'Vous faites partie de l\'élite des utilisateurs !',
        emoji: '🏆',
        color: Colors.purple[600]!,
      );
    }
    if (level == 19) {
      return _BadgeDisplayData(
        name: 'Maître',
        description: 'Votre maîtrise est exceptionnelle !',
        emoji: '👑',
        color: Colors.red[600]!,
      );
    }
    if (level == 29) {
      return _BadgeDisplayData(
        name: 'Champion',
        description: 'Vous êtes un véritable champion !',
        emoji: '🌟',
        color: Colors.amber[600]!,
      );
    }
    if (level == 39) {
      return _BadgeDisplayData(
        name: 'Légende',
        description: 'Votre légende inspire les autres !',
        emoji: '⚡',
        color: Colors.deepPurple[600]!,
      );
    }
    if (level >= 49) {
      return _BadgeDisplayData(
        name: level >= 69 ? 'Transcendant' : 'Haut rang',
        description: 'Atteignez le niveau $level pour ce badge.',
        emoji: level >= 69 ? '🌌' : '🏅',
        color: level >= 69 ? Colors.deepPurple[800]! : Colors.amber[600]!,
      );
    }
    return _BadgeDisplayData(
      name: 'Badge niveau $level',
      description: 'Débloquez ce badge au niveau $level.',
      emoji: '🏅',
      color: Colors.amber[600]!,
    );
  }
}

class _BadgeDisplayData {
  final String name;
  final String description;
  final String emoji;
  final Color color;

  _BadgeDisplayData({
    required this.name,
    required this.description,
    required this.emoji,
    required this.color,
  });
}

class _BadgeProgressTile extends StatelessWidget {
  final String name;
  final String description;
  final String assetPath;
  final Color color;
  final bool isUnlocked;
  final double progress; // 0..1
  final bool isTablet;

  const _BadgeProgressTile({
    required this.name,
    required this.description,
    required this.assetPath,
    required this.color,
    required this.isUnlocked,
    required this.progress,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    // Border radius réduit et hauteur augmentée
    final radius = BorderRadius.circular(isTablet ? 14.0 : 12.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Piste neutre
            Container(
              height: isTablet ? 110.0 : 92.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Remplissage de progression
            ClipRRect(
              borderRadius: radius,
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: isTablet ? 110.0 : 92.0,
                  color: color.withOpacity(isUnlocked ? 0.18 : 0.14),
                ),
              ),
            ),
            // Contenu
            Container(
              height: isTablet ? 110.0 : 92.0,
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 18.0 : 14.0),
              child: Row(
                children: [
                  // Icône circulaire
                  Container(
                    width: isTablet ? 64.0 : 56.0,
                    height: isTablet ? 64.0 : 56.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 2,
                      ),
                      color: Colors.white,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        assetPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stack) => Icon(
                          Icons.emoji_events_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isTablet ? 18.0 : 16.0,
                            fontWeight: FontWeight.w700,
                            color: BadgesScreenColors.darkColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isTablet ? 14.0 : 12.5,
                            color: BadgesScreenColors.darkColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isUnlocked ? Icons.verified : Icons.lock_outline,
                    color: isUnlocked ? color : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
