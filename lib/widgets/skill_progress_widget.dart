import 'package:flutter/material.dart';
import 'active_goal_calendar_widget.dart';

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

class HomeColors {
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

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Home',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: SkillProgressColors.darkColor,
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
              color: const Color.fromARGB(
                255,
                255,
                255,
                255,
              ).withValues(alpha: 0.1),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: ActiveGoalCalendarWidget(onSwitchTab: onSwitchTab),
              ),
            ),
          ),
        );
      },
    );
  }
}
