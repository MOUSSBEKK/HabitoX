import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../widgets/png_badges_grid.dart';

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
                  // Contenu des onglets
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          isTablet ? 28.0 : 24.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: BadgesScreenColors.darkColor.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: PngBadgesGrid(),
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
}
