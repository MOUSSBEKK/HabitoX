import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../services/goal_service.dart';
import '../widgets/user_profile_widget.dart';
import '../widgets/global_stats_widget.dart';

// Couleurs du design épuré
class ProfileScreenColors {
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;
        final headerHeight = isTablet ? 280.0 : 240.0;
        final headerPadding = isTablet ? 60.0 : 40.0;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: ProfileScreenColors.lightColor.withOpacity(0.1),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header avec design épuré
                  SliverAppBar(
                    expandedHeight: headerHeight,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          color: ProfileScreenColors.lightColor.withOpacity(
                            0.3,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            padding,
                            headerPadding,
                            padding,
                            padding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 32.0 : 28.0,
                                  ),
                                  border: Border.all(
                                    color: ProfileScreenColors.lightColor
                                        .withOpacity(0.4),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ProfileScreenColors.darkColor
                                          .withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: isTablet ? 44.0 : 36.0,
                                  color: ProfileScreenColors.darkColor,
                                ),
                              ),
                              SizedBox(height: isTablet ? 20.0 : 16.0),
                              Text(
                                '👤 Mon Profil',
                                style: TextStyle(
                                  fontSize: isTablet ? 32.0 : 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: ProfileScreenColors.darkColor,
                                ),
                              ),
                              SizedBox(height: isTablet ? 12.0 : 10.0),
                              // Médaille actuelle de l'utilisateur
                              Consumer<GoalService>(
                                builder: (context, goalService, child) {
                                  final highestGrade =
                                      goalService.highestGradeAchieved;
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 16.0 : 12.0,
                                      vertical: isTablet ? 8.0 : 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ProfileScreenColors.primaryColor
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(
                                        isTablet ? 20.0 : 16.0,
                                      ),
                                      border: Border.all(
                                        color: ProfileScreenColors.primaryColor
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          highestGrade.emoji,
                                          style: TextStyle(
                                            fontSize: isTablet ? 20.0 : 18.0,
                                          ),
                                        ),
                                        SizedBox(width: isTablet ? 8.0 : 6.0),
                                        Text(
                                          highestGrade.title,
                                          style: TextStyle(
                                            fontSize: isTablet ? 18.0 : 16.0,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                ProfileScreenColors.darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: isTablet ? 12.0 : 10.0),
                              Text(
                                'Suivez votre progression et vos statistiques',
                                style: TextStyle(
                                  fontSize: isTablet ? 18.0 : 16.0,
                                  color: ProfileScreenColors.darkColor
                                      .withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(right: padding, top: padding),
                        child: IconButton(
                          onPressed: () => _showProfileSettings(context),
                          icon: Container(
                            padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
                            decoration: BoxDecoration(
                              color: ProfileScreenColors.primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 18.0 : 16.0,
                              ),
                            ),
                            child: Icon(
                              Icons.settings,
                              color: ProfileScreenColors.primaryColor,
                              size: isTablet ? 28.0 : 24.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Contenu principal
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        children: [
                          // Widget du profil utilisateur avec design amélioré
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 24.0 : 20.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ProfileScreenColors.primaryColor
                                      .withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const UserProfileWidget(),
                          ),

                          SizedBox(height: isTablet ? 32.0 : 24.0),

                          // Section Statistiques Globales
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 24.0 : 20.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: ProfileScreenColors.primaryColor
                                      .withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const GlobalStatsWidget(),
                          ),

                          SizedBox(height: isTablet ? 32.0 : 24.0),
                        ],
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

  void _showProfileSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '⚙️ Paramètres du Profil',
          style: TextStyle(
            color: ProfileScreenColors.darkColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Options de configuration du profil utilisateur',
          style: TextStyle(color: ProfileScreenColors.darkColor, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: TextStyle(
                color: ProfileScreenColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
