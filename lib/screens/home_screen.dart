import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:ui';
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
      bottomNavigationBar: _buildModernBottomNavBar(),
      // Bouton de débogage flottant (seulement en mode debug)
    );
  }

  Widget _buildModernBottomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _buildNavBarContent(),
      ),
    );
  }

  Widget _buildNavBarContent() {
    Widget content = Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: FontAwesomeIcons.home,
                  label: AppLocalizations.of(context)!.home,
                  index: 0,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.listCheck,
                  label: AppLocalizations.of(context)!.nav_objectives,
                  index: 1,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.trophy,
                  label: AppLocalizations.of(context)!.nav_badges,
                  index: 2,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.user,
                  label: AppLocalizations.of(context)!.nav_profile,
                  index: 3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: _buildAddButton(),
          ),
        ],
      ),
    );

    // Pour iOS, ajouter un effet de verre avec backdrop filter
    if (_isIOS()) {
      return _buildLiquidGlassEffect(content);
    }

    return content;
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // decoration: BoxDecoration(
        //   color: isSelected
        //       ? const Color.fromARGB(255, 48, 48, 48).withOpacity(0.2)
        //       : Colors.transparent,
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primaryFixed,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primaryFixed,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: HomeColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: HomeColors.primaryColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _showAddGoalBottomSheet(context),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildLiquidGlassEffect(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  bool _isIOS() {
    return !kIsWeb && Platform.isIOS;
  }
}
