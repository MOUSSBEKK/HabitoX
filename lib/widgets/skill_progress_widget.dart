import 'package:flutter/material.dart';
import 'active_goal_calendar_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            title: Text('HabitoX'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.chartLine,
                  size: 20,
                  color: Color(0xFF1F4843),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.circleArrowUp,
                  size: 20,
                  color: Color(0xFF1F4843),
                ),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(226, 239, 243, 1),
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
