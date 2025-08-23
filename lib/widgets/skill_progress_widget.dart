import 'package:flutter/material.dart';
import 'active_goal_widget.dart';
import 'calendar_heatmap_widget.dart';

// Couleurs du design épuré
class SkillProgressColors {
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte
}

class SkillProgressWidget extends StatelessWidget {
  final Function(int)? onSwitchTab;

  const SkillProgressWidget({super.key, this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;
        final spacing = isTablet ? 40.0 : 32.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '📊 Tableau de Bord',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: SkillProgressColors.darkColor,
                fontSize: isTablet ? 28.0 : 24.0,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: SkillProgressColors.lightColor.withOpacity(0.1),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    // Widget de l'objectif actif avec design épuré
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          isTablet ? 28.0 : 24.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: SkillProgressColors.primaryColor.withOpacity(
                              0.1,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ActiveGoalWidget(onSwitchTab: onSwitchTab),
                    ),

                    SizedBox(height: spacing),

                    // Widget du calendrier heatmap avec design épuré
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          isTablet ? 28.0 : 24.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: SkillProgressColors.primaryColor.withOpacity(
                              0.1,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const CalendarHeatmapWidget(),
                    ),

                    SizedBox(height: spacing + 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
