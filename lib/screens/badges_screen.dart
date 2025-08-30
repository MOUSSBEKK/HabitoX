import 'package:flutter/material.dart';
import '../widgets/aura_badges_widget.dart';
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
          appBar: AppBar(
            title: Text(
              'Achievements',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.greenAccent,
                fontSize: isTablet ? 28.0 : 24.0,
              ),
            ),
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(226, 239, 243, 1),
            foregroundColor: Colors.white,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: BadgesScreenColors.lightColor.withValues(alpha: 0.1),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 24.0 : 20.0),
                  // Contenu des onglets
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Onglet Badges Calendrier (PNG)
                        Container(
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

                        // Onglet Badges Aura
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: padding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 28.0 : 24.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: BadgesScreenColors.lightColor.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          // child: const AuraBadgesWidget(),
                        ),
                      ],
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
}
