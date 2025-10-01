import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';
import 'badges_screen.dart';
import '../widgets/skill_progress_widget.dart';
import '../models/goal.dart';
import '../widgets/add_goal_bottom_sheet.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final isSmallScreen = screenWidth < 400;

        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              // Navigation items - s'adapte à la taille de l'écran
              if (isSmallScreen) ...[
                // Pour les petits écrans, utiliser un layout plus compact
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: HugeIconsStroke.home03,
                        iconSelected: HugeIconsSolid.home03,
                        label: AppLocalizations.of(context)!.home,
                        index: 0,
                        isCompact: true,
                      ),
                      _buildNavItem(
                        icon: HugeIconsStroke.task01,
                        iconSelected: HugeIconsSolid.task01,
                        label: AppLocalizations.of(context)!.nav_objectives,
                        index: 1,
                        isCompact: true,
                      ),
                      _buildNavItem(
                        icon: HugeIconsStroke.award01,
                        iconSelected: HugeIconsSolid.award01,
                        label: AppLocalizations.of(context)!.nav_badges,
                        index: 2,
                        isCompact: true,
                      ),
                      _buildNavItem(
                        icon: HugeIconsStroke.settings02,
                        iconSelected: HugeIconsSolid.settings02,
                        label: AppLocalizations.of(context)!.nav_profile,
                        index: 3,
                        isCompact: true,
                      ),
                    ],
                  ),
                ),
                // Bouton d'ajout plus petit sur les petits écrans
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                  child: _buildAddButton(isCompact: true),
                ),
              ] else ...[
                // Pour les écrans plus grands, utiliser le layout original
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: HugeIconsStroke.home03,
                        iconSelected: HugeIconsSolid.home03,
                        label: AppLocalizations.of(context)!.home,
                        index: 0,
                      ),
                      _buildNavItem(
                        icon: HugeIconsStroke.task01,
                        iconSelected: HugeIconsSolid.task01,
                        label: AppLocalizations.of(context)!.nav_objectives,
                        index: 1,
                      ),
                      _buildNavItem(
                        icon: HugeIconsStroke.award01,
                        iconSelected: HugeIconsSolid.award01,
                        label: AppLocalizations.of(context)!.nav_badges,
                        index: 2,
                      ),
                      _buildNavItem(
                        icon: HugeIconsStroke.settings02,
                        iconSelected: HugeIconsSolid.settings02,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData iconSelected,
    required String label,
    required int index,
    bool isCompact = false,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 8 : 16,
          vertical: isCompact ? 4 : 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? iconSelected : icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primaryFixed,
              size: isCompact ? 18 : 20,
            ),
            SizedBox(height: isCompact ? 2 : 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primaryFixed,
                fontSize: isCompact ? 9 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton({bool isCompact = false}) {
    final size = isCompact ? 48.0 : 56.0;
    final iconSize = isCompact ? 24.0 : 28.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: HomeColors.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: HomeColors.primaryColor.withOpacity(0.4),
            blurRadius: isCompact ? 6 : 8,
            offset: Offset(0, isCompact ? 3 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: () => _showAddGoalBottomSheet(context),
          child: Icon(Icons.add, color: Colors.white, size: iconSize),
        ),
      ),
    );
  }
}
