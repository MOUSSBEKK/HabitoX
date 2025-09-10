import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../l10n/app_localizations.dart';

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
              color: Theme.of(context).colorScheme.surface,
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
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 24.0 : 12.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Consumer<UserProfileService>(
                      builder: (context, profileService, child) {
                        final level =
                            profileService.userProfile?.currentLevel ?? 1;

                        final badgeLevels = [1, 5, 10, 15, 20, 25, 30, 35, 40];
                        int lastUnlockedBadgeLevel = 1;
                        for (int badgeLevel in badgeLevels) {
                          if (level >= badgeLevel) {
                            lastUnlockedBadgeLevel = badgeLevel;
                          } else {
                            break;
                          }
                        }

                        final assetPath = _getBadgeAssetForLevel(
                          lastUnlockedBadgeLevel,
                        );
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
                              AppLocalizations.of(context)!.badge_earned,
                              style: TextStyle(
                                fontSize: isTablet ? 16.0 : 14.0,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(
                                  context,
                                ).colorScheme.tertiaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AppLocalizations.of(context)!.badge_level} $lastUnlockedBadgeLevel',
                              style: TextStyle(
                                fontSize: isTablet ? 20.0 : 16.0,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(
                                  context,
                                ).colorScheme.tertiaryContainer,
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
                            5,
                            10,
                            20,
                            30,
                            40,
                            50,
                            60,
                            70,
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

    // Mapping des niveaux de badges vers les indices des assets
    final badgeLevels = [1, 5, 10, 15, 20, 25, 30, 35, 40];
    int badgeIndex = 0;

    for (int i = 0; i < badgeLevels.length; i++) {
      if (level >= badgeLevels[i]) {
        badgeIndex = i;
      } else {
        break;
      }
    }

    badgeIndex = badgeIndex.clamp(0, assetFiles.length - 1);
    return 'assets/badges/${assetFiles[badgeIndex]}';
  }

  String _getBadgeAssetByIndex(int position) {
    final safe = position.clamp(1, 10);
    return 'assets/badges/BADGE$safe.png';
  }

  _BadgeDisplayData _badgeDisplayData(int level) {
    if (level == 1) {
      return _BadgeDisplayData(
        name: AppLocalizations.of(context)!.badge1_title,
        description: AppLocalizations.of(context)!.badge1_desc,
        color: Colors.grey[600]!,
      );
    }
    if (level == 5) {
      return _BadgeDisplayData(
        name: AppLocalizations.of(context)!.badge2_title,
        description: AppLocalizations.of(context)!.badge2_desc,
        color: Colors.orange[600]!,
      );
    }
    if (level == 10) {
      return _BadgeDisplayData(
        name: AppLocalizations.of(context)!.badge3_title,
        description: AppLocalizations.of(context)!.badge3_desc,
        color: Colors.purple[600]!,
      );
    }
    if (level == 20) {
      return _BadgeDisplayData(
        name: AppLocalizations.of(context)!.badge4_title,
        description: AppLocalizations.of(context)!.badge4_desc,
        color: Colors.red[600]!,
      );
    }
    if (level == 30) {
      return _BadgeDisplayData(
        name: AppLocalizations.of(context)!.badge5_title,
        description: AppLocalizations.of(context)!.badge5_desc,
        color: Colors.amber[600]!,
      );
    }
    if (level == 40) {
      return _BadgeDisplayData(
        name: AppLocalizations.of(context)!.badge6_title,
        description: AppLocalizations.of(context)!.badge6_desc,
        color: Colors.deepPurple[600]!,
      );
    }
    if (level >= 50) {
      return _BadgeDisplayData(
        name: level >= 69
            ? AppLocalizations.of(context)!.badge9_title
            : AppLocalizations.of(context)!.badge7_title,
        description: 'Reach level $level for this badge..',
        color: level >= 69 ? Colors.deepPurple[800]! : Colors.amber[600]!,
      );
    }
    return _BadgeDisplayData(
      name: '${AppLocalizations.of(context)!.badge_level} $level',
      description: 'Unlock this badge at level $level.',
      color: Colors.amber[600]!,
    );
  }
}

class _BadgeDisplayData {
  final String name;
  final String description;
  final Color color;

  _BadgeDisplayData({
    required this.name,
    required this.description,
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
                color: Theme.of(context).colorScheme.primary,
                borderRadius: radius,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
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
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiaryContainer,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isTablet ? 14.0 : 12.5,
                            color: Theme.of(context)
                                .colorScheme
                                .tertiaryContainer
                                .withValues(alpha: 0.7),
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
