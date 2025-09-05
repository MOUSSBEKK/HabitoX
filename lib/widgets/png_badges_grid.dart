import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../models/user_profile.dart';
import '../constants/app_colors.dart';

class PngBadgesGrid extends StatelessWidget {
  const PngBadgesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> assetPaths = [
      "BADGE1.png",
      "BADGE2.png",
      "BADGE3.png",
      "BADGE4.png",
      "BADGE5.png",
      "BADGE6.png",
      "BADGE8.png",
      "BADGE9.png",
      "BADGE10.png",
    ];
    return Consumer<UserProfileService>(
      builder: (context, profileService, child) {
        final level = profileService.userProfile?.currentLevel ?? 1;

        // Badges tous les 5 niveaux
        final badgeLevels = [1, 5, 10, 15, 20, 25, 30, 35, 40]; // Niveaux où on débloque des badges
        final totalBadges = badgeLevels.length;
        final currentXp = profileService.userProfile?.experiencePoints ?? 0;
        final badges = List.generate(totalBadges, (index) {
          final badgeLevel = badgeLevels[index];
          final isUnlocked = level >= badgeLevel;
          
          // Calculer la progression vers ce badge
          double progressToThisBadge = 0.0;
          if (!isUnlocked) {
            final xpNeededForThisBadge = UserProfile.getTotalXpForLevel(badgeLevel);
            final previousBadgeLevel = index > 0 ? badgeLevels[index - 1] : 1;
            final xpNeededForPreviousBadge = index > 0 ? UserProfile.getTotalXpForLevel(previousBadgeLevel) : 0;
            
            if (currentXp > xpNeededForPreviousBadge) {
              progressToThisBadge = (currentXp - xpNeededForPreviousBadge) / (xpNeededForThisBadge - xpNeededForPreviousBadge);
              progressToThisBadge = progressToThisBadge.clamp(0.0, 1.0);
            }
          }
          
          return _BadgeMeta(
            assetPath: 'assets/badges/${assetPaths[index]}',
            requiredLevel: badgeLevel,
            isUnlocked: isUnlocked,
            progressToUnlock: progressToThisBadge,
          );
        });

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) => _BadgeTile(meta: badges[index]),
        );
      },
    );
  }
}

class _BadgeMeta {
  final String assetPath;
  final int requiredLevel;
  final bool isUnlocked;
  final double progressToUnlock;

  _BadgeMeta({
    required this.assetPath,
    required this.requiredLevel,
    required this.isUnlocked,
    this.progressToUnlock = 0.0,
  });
}

class _BadgeTile extends StatelessWidget {
  final _BadgeMeta meta;
  const _BadgeTile({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(meta.assetPath, fit: BoxFit.contain),
                ),
                if (!meta.isUnlocked)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                if (!meta.isUnlocked)
                  Icon(Icons.lock, color: Colors.grey[600], size: 28),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Level ${meta.requiredLevel}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkColor.withValues(alpha: 0.8),
            ),
          ),
          // Barre de progression pour les badges non débloqués
          if (!meta.isUnlocked && meta.progressToUnlock > 0) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: meta.progressToUnlock,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${(meta.progressToUnlock * 100).toInt()}%',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
