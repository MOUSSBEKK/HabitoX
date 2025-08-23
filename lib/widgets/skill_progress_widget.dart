import 'package:flutter/material.dart';
import 'active_goal_widget.dart';
import 'global_stats_widget.dart';
import 'calendar_heatmap_widget.dart';
import 'badges_widget.dart';

class SkillProgressWidget extends StatelessWidget {
  const SkillProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HabitoX - Focus sur un Objectif"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Widget de l'objectif actif
            const ActiveGoalWidget(),

            const SizedBox(height: 32),

            // Widget du calendrier heatmap
            const CalendarHeatmapWidget(),

            const SizedBox(height: 32),

            // Widget des badges
            const BadgesWidget(),

            const SizedBox(height: 32),

            // Statistiques globales
            const GlobalStatsWidget(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
