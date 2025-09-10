import 'package:flutter/material.dart';
import 'active_goal_calendar_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                icon: FaIcon(FontAwesomeIcons.chartLine, size: 22),
              ),
              IconButton(
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.circleArrowUp, size: 22),
              ),
            ],
          ),
          body: Container(
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
