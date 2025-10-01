import 'package:flutter/material.dart';
import 'active_goal_calendar_widget.dart';
import '../screens/data_analytics_screen.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class SkillProgressWidget extends StatelessWidget {
  final Function(int)? onSwitchTab;

  const SkillProgressWidget({super.key, this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Utiliser MediaQuery.sizeOf pour de meilleures performances
        final screenWidth = MediaQuery.sizeOf(context).width;
        final screenHeight = MediaQuery.sizeOf(context).height;

        // Déterminer le type d'écran basé sur la largeur
        final isTablet = screenWidth > 600;
        final isSmallScreen = screenWidth < 360;

        // Calculer le padding adaptatif
        double padding;
        if (isSmallScreen) {
          padding = 16.0;
        } else if (isTablet) {
          padding = 32.0;
        } else {
          padding = 20.0;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('HabitoX'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DataAnalyticsScreen(),
                    ),
                  );
                },
                icon: Icon(
                  HugeIconsStroke.chart01,
                  size: isSmallScreen ? 20 : 22,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // minHeight:
                  //     screenHeight -
                  //     kToolbarHeight -
                  //     MediaQuery.of(context).padding.top -
                  //     MediaQuery.of(context).padding.bottom -
                  //     (padding * 2),
                ),
                child: ActiveGoalCalendarWidget(onSwitchTab: onSwitchTab),
              ),
            ),
          ),
        );
      },
    );
  }
}
