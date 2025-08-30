import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
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
    ];
    return Consumer<UserProfileService>(
      builder: (context, profileService, child) {
        final level = profileService.userProfile?.auraLevel ?? 1;

        // 10 badges, le premier débloqué par défaut (Level 1)
        final totalBadges = 7;
        final badges = List.generate(totalBadges, (index) {
          final badgeLevel = index + 1; // Level 1..10
          final isUnlocked = badgeLevel == 1 || level >= badgeLevel;
          return _BadgeMeta(
            assetPath: 'assets/badges/${assetPaths[index]}',
            requiredLevel: badgeLevel,
            isUnlocked: isUnlocked,
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

  _BadgeMeta({
    required this.assetPath,
    required this.requiredLevel,
    required this.isUnlocked,
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
