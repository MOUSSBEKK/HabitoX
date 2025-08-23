import 'package:flutter/material.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'test_screen.dart';
import 'badges_screen.dart';
import '../widgets/skill_progress_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              SkillProgressWidget(onSwitchTab: _switchToTab),
              const GoalsScreen(),
              const BadgesScreen(),
              const ProfileScreen(),
              const TestScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.grey[600],
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 14.0 : 12.0,
              ),
              unselectedLabelStyle: TextStyle(fontSize: isTablet ? 14.0 : 12.0),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard, size: isTablet ? 28.0 : 24.0),
                  label: 'Tableau de Bord',
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.science, size: isTablet ? 28.0 : 24.0),
                  label: 'Test',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
