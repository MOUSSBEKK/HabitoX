import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../widgets/user_profile_widget.dart';
import '../widgets/aura_badges_widget.dart';

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
        final headerHeight = isTablet ? 250.0 : 200.0;
        final headerPadding = isTablet ? 80.0 : 60.0;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo.withOpacity(0.1),
                  Colors.purple.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header avec design premium
                  SliverAppBar(
                    expandedHeight: headerHeight,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.indigo.withOpacity(0.3),
                              Colors.purple.withOpacity(0.2),
                              Colors.indigo.withOpacity(0.1),
                            ],
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
                                padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 36.0 : 30.0,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.indigo.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: isTablet ? 48.0 : 40.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: isTablet ? 20.0 : 16.0),
                              Text(
                                '👤 Mon Profil',
                                style: TextStyle(
                                  fontSize: isTablet ? 32.0 : 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: isTablet ? 10.0 : 8.0),
                              Text(
                                'Suivez votre progression et votre aura',
                                style: TextStyle(
                                  fontSize: isTablet ? 18.0 : 16.0,
                                  color: Colors.white.withOpacity(0.9),
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
                            padding: EdgeInsets.all(isTablet ? 10.0 : 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                isTablet ? 16.0 : 12.0,
                              ),
                            ),
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
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
                                isTablet ? 28.0 : 24.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const UserProfileWidget(),
                          ),

                          SizedBox(height: isTablet ? 40.0 : 32.0),

                          // Section Aura avec design premium
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 28.0 : 24.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildAuraSection(isTablet),
                          ),

                          SizedBox(height: isTablet ? 40.0 : 32.0),

                          // Section Historique Aura
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 28.0 : 24.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildAuraHistory(isTablet),
                          ),

                          SizedBox(height: isTablet ? 40.0 : 32.0),

                          // Section Conseils Aura
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                isTablet ? 28.0 : 24.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: _buildAuraTips(isTablet),
                          ),

                          SizedBox(height: isTablet ? 48.0 : 40.0),
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

  Widget _buildAuraSection(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.indigo.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 28.0 : 24.0),
        border: Border.all(color: Colors.purple.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.purple,
                  size: isTablet ? 28.0 : 24.0,
                ),
              ),
              SizedBox(width: isTablet ? 20.0 : 16.0),
              Expanded(
                child: Text(
                  '✨ Système d\'Aura',
                  style: TextStyle(
                    fontSize: isTablet ? 24.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _showAuraInfo(context),
                icon: Container(
                  padding: EdgeInsets.all(isTablet ? 10.0 : 8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(isTablet ? 16.0 : 12.0),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.purple,
                    size: isTablet ? 24.0 : 20.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),
          const AuraBadgesWidget(),
        ],
      ),
    );
  }

  Widget _buildAuraHistory(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.withOpacity(0.1), Colors.cyan.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 28.0 : 24.0),
        border: Border.all(color: Colors.teal.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
                ),
                child: Icon(
                  Icons.timeline,
                  color: Colors.teal,
                  size: isTablet ? 28.0 : 24.0,
                ),
              ),
              SizedBox(width: isTablet ? 20.0 : 16.0),
              Expanded(
                child: Text(
                  '📈 Historique de l\'Aura',
                  style: TextStyle(
                    fontSize: isTablet ? 24.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),
          Consumer<UserProfileService>(
            builder: (context, profileService, child) {
              final profile = profileService.userProfile;
              return Column(
                children: [
                  _buildHistoryItem(
                    'Niveau actuel',
                    '${profile?.auraLevel ?? 0}',
                    Icons.star,
                    Colors.amber,
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 16.0 : 12.0),
                  _buildHistoryItem(
                    'Points d\'aura',
                    '${profile?.auraPoints ?? 0}',
                    Icons.auto_awesome,
                    Colors.purple,
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 16.0 : 12.0),
                  _buildHistoryItem(
                    'Jours consécutifs',
                    '${profile?.consecutiveDays ?? 0}',
                    Icons.local_fire_department,
                    Colors.orange,
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 16.0 : 12.0),
                  _buildHistoryItem(
                    'Meilleure série',
                    '${profile?.maxConsecutiveDays ?? 0}',
                    Icons.emoji_events,
                    Colors.amber,
                    isTablet,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAuraTips(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.amber.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isTablet ? 28.0 : 24.0),
        border: Border.all(color: Colors.orange.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 16.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.orange,
                  size: isTablet ? 28.0 : 24.0,
                ),
              ),
              SizedBox(width: isTablet ? 20.0 : 16.0),
              Expanded(
                child: Text(
                  '💡 Conseils pour l\'Aura',
                  style: TextStyle(
                    fontSize: isTablet ? 24.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 24.0 : 20.0),
          _buildTipItem(
            '🎯 Complétez vos objectifs quotidiennement pour gagner de l\'aura',
            Colors.green,
            isTablet,
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),
          _buildTipItem(
            '🔥 Maintenez des séries consécutives pour des bonus d\'aura',
            Colors.orange,
            isTablet,
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),
          _buildTipItem(
            '⚠️ Évitez de manquer des jours pour ne pas perdre d\'aura',
            Colors.red,
            isTablet,
          ),
          SizedBox(height: isTablet ? 16.0 : 12.0),
          _buildTipItem(
            '🏆 Débloquez des badges tous les 5 niveaux d\'aura',
            Colors.purple,
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: isTablet ? 24.0 : 20.0),
          SizedBox(width: isTablet ? 16.0 : 12.0),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 18.0 : 16.0,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 20.0 : 18.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip, Color color, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isTablet ? 20.0 : 16.0),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        tip,
        style: TextStyle(
          fontSize: isTablet ? 18.0 : 16.0,
          color: color.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showProfileSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('⚙️ Paramètres du Profil'),
        content: const Text('Options de configuration du profil utilisateur'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAuraInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('✨ Qu\'est-ce que l\'Aura ?'),
        content: const Text(
          'L\'Aura est votre énergie de progression. Gagnez-en en complétant vos objectifs et maintenez des séries consécutives pour des bonus. Évitez de manquer des jours pour ne pas en perdre !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris !'),
          ),
        ],
      ),
    );
  }
}
