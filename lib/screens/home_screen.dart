import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'badges_screen.dart';
import '../widgets/skill_progress_widget.dart';
import '../widgets/theme_toggle_widget.dart';
import '../models/goal.dart';
import '../widgets/add_goal_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _switchToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showAddGoalBottomSheet(BuildContext context, {Goal? goal}) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => AddGoalBottomSheet(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            title: const Text('HabitoX'),
            actions: [const QuickThemeToggle(), const SizedBox(width: 8)],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              SkillProgressWidget(onSwitchTab: _switchToTab),
              const GoalsScreen(),
              const BadgesScreen(),
              const ProfileScreen(),
            ],
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () => _showAddGoalBottomSheet(context),
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.house,
                  size: isTablet ? 28.0 : 24.0,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.bullseye,
                  size: isTablet ? 28.0 : 24.0,
                ),
                label: 'Objectifs',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.trophy,
                  size: isTablet ? 28.0 : 24.0,
                ),
                label: 'Badges',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  size: isTablet ? 28.0 : 24.0,
                ),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
