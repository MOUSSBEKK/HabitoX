import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../widgets/goal_card.dart';
import '../widgets/add_goal_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

// Couleurs du design épuré
class GoalsColors {
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  int _selectedIndex = 0; // 0: Actifs, 1: Complétés, 2: Archivés

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;
        // final headerPadding = isTablet ? 80.0 : 60.0;

        return Scaffold(
          appBar: AppBar(title: Text('Objectifs')),
          body: Container(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: isTablet ? 24.0 : 20.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 20.0 : 12.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildSegmentButton(
                          AppLocalizations.of(context)!.objectives_actif,
                          0,
                          isTablet,
                        ),
                        _buildSegmentButton(
                          AppLocalizations.of(context)!.objectives_completed,
                          1,
                          isTablet,
                        ),
                        _buildSegmentButton(
                          AppLocalizations.of(context)!.objectives_archived,
                          2,
                          isTablet,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 24.0 : 20.0),
                  Expanded(child: _buildCurrentTabContent(isTablet)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGoalsList(
    BuildContext context,
    List<Goal> Function(GoalService) goalsSelector,
    String emptyTitle,
    String emptySubtitle,
    IconData emptyIcon,
    bool isTablet,
  ) {
    return Consumer<GoalService>(
      builder: (context, goalService, child) {
        final goals = goalsSelector(goalService);

        if (goals.isEmpty) {
          return Container(
            padding: EdgeInsets.all(isTablet ? 48.0 : 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(emptyIcon, size: isTablet ? 100.0 : 80.0),
                SizedBox(height: isTablet ? 32.0 : 24.0),
                Text(
                  emptyTitle.toUpperCase(),
                  style: TextStyle(
                    fontSize: isTablet ? 24.0 : 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 16.0 : 12.0),
                Text(
                  emptySubtitle,
                  style: TextStyle(
                    fontSize: isTablet ? 18.0 : 16.0,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final goal = goals[index];
            return Padding(
              padding: EdgeInsets.only(bottom: isTablet ? 20.0 : 16.0),
              child: GoalCard(
                goal: goal,
                onEdit: () => _showEditGoalDialog(context, goal),
                onDelete: () => _showDeleteConfirmation(context, goal),
                onToggleStatus: () => _toggleGoalStatus(goal),
              ),
            );
          },
        );
      },
    );
  }

  // Bouton segmenté réutilisable
  Widget _buildSegmentButton(String label, int index, bool isTablet) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: isTablet ? 14 : 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? GoalsColors.primaryColor
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(isTablet ? 14 : 8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).colorScheme.tertiaryFixed
                    : Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Contenu en fonction de l'onglet sélectionné
  Widget _buildCurrentTabContent(bool isTablet) {
    if (_selectedIndex == 0) {
      return _buildGoalsList(
        context,
        (goalService) => goalService.goals.where((g) => g.isActive).toList(),
        AppLocalizations.of(context)!.objectives_actif_empty_title,
        AppLocalizations.of(context)!.objectives_actif_empty_subtitle,
        FontAwesomeIcons.flag,
        isTablet,
      );
    }
    if (_selectedIndex == 1) {
      return _buildGoalsList(
        context,
        (goalService) => goalService.completedGoals,
        AppLocalizations.of(context)!.objectives_completed_empty_title,
        AppLocalizations.of(context)!.objectives_completed_empty_subtitle,
        FontAwesomeIcons.checkCircle,
        isTablet,
      );
    }
    return _buildGoalsList(
      context,
      (goalService) => goalService.goals
          .where((g) => !g.isActive && !g.isCompleted)
          .toList(),
      AppLocalizations.of(context)!.objectives_archived_empty_title,
      AppLocalizations.of(context)!.objectives_archived_empty_subtitle,
      HugeIconsStroke.archive03,
      isTablet,
    );
  }

  void _showAddGoalBottomSheet(BuildContext context, {Goal? goal}) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => AddGoalBottomSheet(goal: goal),
    );
  }

  void _showEditGoalDialog(BuildContext context, Goal goal) {
    _showAddGoalBottomSheet(context, goal: goal);
  }

  void _showDeleteConfirmation(BuildContext context, Goal goal) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Confirmer la suppression',
      message:
          'Êtes-vous sûr de vouloir supprimer l\'objectif "${goal.title}" ?',
      okLabel: 'Supprimer',
      cancelLabel: AppLocalizations.of(context)!.cancel,
      isDestructiveAction: true,
    );

    if (result == OkCancelResult.ok) {
      context.read<GoalService>().deleteGoal(goal.id, context);
    }
  }

  void _toggleGoalStatus(Goal goal) {
    if (goal.isActive) {
      // Désactiver l'objectif en supprimant son statut actif
      final goalService = context.read<GoalService>();
      // Créer une copie de l'objectif sans le statut actif
      final updatedGoal = goal.copyWith(isActive: false);
      goalService.updateGoal(updatedGoal, context);
    } else {
      // Activer l'objectif
      context.read<GoalService>().activateGoal(goal.id, context);
    }
  }
}
