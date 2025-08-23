import 'package:flutter/material.dart';
import 'active_goal_widget.dart';
import 'global_stats_widget.dart';
import 'calendar_heatmap_widget.dart';

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
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                fontSize: isTablet ? 28.0 : 24.0,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.indigo.withOpacity(0.05), Colors.white],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    // Widget de l'objectif actif avec design amélioré
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
                      child: ActiveGoalWidget(onSwitchTab: onSwitchTab),
                    ),

                    SizedBox(height: spacing),

                    // Widget du calendrier heatmap avec design premium
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
                      child: const CalendarHeatmapWidget(),
                    ),

                    SizedBox(height: spacing),

                    // Widget des statistiques globales avec design moderne
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
                      child: const GlobalStatsWidget(),
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
