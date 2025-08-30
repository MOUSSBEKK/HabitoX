import 'package:flutter/material.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'badges_screen.dart';
import '../widgets/skill_progress_widget.dart';
import '../models/goal.dart';
import '../widgets/add_goal_bottom_sheet.dart';

// Couleurs du design épuré
class HomeColors {
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte
}

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddGoalBottomSheet(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          backgroundColor: Colors.white,
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
                  backgroundColor: HomeColors.primaryColor,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.add),
                )
              : null,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: HomeColors.darkColor.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: isTablet
                  ? BottomNavigationBarType.fixed
                  : BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: HomeColors.primaryColor,
              unselectedItemColor: HomeColors.darkColor.withValues(alpha: 0.5),
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 14.0 : 12.0,
                color: HomeColors.primaryColor,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: isTablet ? 14.0 : 12.0,
                color: HomeColors.darkColor.withValues(alpha: 0.5),
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    size: isTablet ? 28.0 : 24.0,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.flag, size: isTablet ? 28.0 : 24.0),
                  label: 'Objectifs',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events, size: isTablet ? 28.0 : 24.0),
                  label: 'Badges',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: isTablet ? 28.0 : 24.0),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
