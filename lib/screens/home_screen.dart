import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'badges_screen.dart';
import '../widgets/skill_progress_widget.dart';
import '../models/goal.dart';
import '../widgets/add_goal_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../l10n/app_localizations.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

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
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => AddGoalBottomSheet(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          extendBody: true,
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
          bottomNavigationBar: SizedBox(width: double.infinity, height: 144, child: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 16), child: FloatingNavbar(
            currentIndex: _currentIndex,
            onTap: (int val) {
              setState(() {
                _currentIndex = val;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: HomeColors.primaryColor,
            unselectedItemColor: HomeColors.darkColor.withValues(alpha: 0.6),
            selectedBackgroundColor: HomeColors.primaryColor.withValues(alpha: 0.15),
            borderRadius: 16,
            itemBorderRadius: 8,
            margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
            elevation: 8,
            width: double.infinity,
            items: [
              FloatingNavbarItem(
                icon: FontAwesomeIcons.house,
                title: AppLocalizations.of(context)!.home,
              ),
              FloatingNavbarItem(
                icon: FontAwesomeIcons.bullseye,
                title: AppLocalizations.of(context)!.nav_objectives,
              ),
              FloatingNavbarItem(
                icon: FontAwesomeIcons.award,
                title: AppLocalizations.of(context)!.nav_badges,
              ),
              FloatingNavbarItem(
                icon: FontAwesomeIcons.user,
                title: AppLocalizations.of(context)!.nav_profile,
              ),
            ],
          ),
          ),
          ),
          // Bouton de débogage flottant (seulement en mode debug)
        );
  }
}
