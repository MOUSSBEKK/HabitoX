import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../widgets/goal_card.dart';
import '../widgets/add_goal_bottom_sheet.dart';

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

class _GoalsScreenState extends State<GoalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final padding = isTablet ? 32.0 : 20.0;
        // final headerPadding = isTablet ? 80.0 : 60.0;

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: GoalsColors.lightColor.withOpacity(0.1),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header avec design épuré
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(
                  //     padding,
                  //     headerPadding,
                  //     padding,
                  //     padding,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: GoalsColors.lightColor.withOpacity(0.3),
                  //     borderRadius: const BorderRadius.only(
                  //       bottomLeft: Radius.circular(30),
                  //       bottomRight: Radius.circular(30),
                  //     ),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Container(
                  //             padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
                  //             decoration: BoxDecoration(
                  //               color: GoalsColors.primaryColor.withOpacity(
                  //                 0.15,
                  //               ),
                  //               borderRadius: BorderRadius.circular(
                  //                 isTablet ? 24.0 : 20.0,
                  //               ),
                  //               border: Border.all(
                  //                 color: GoalsColors.primaryColor.withOpacity(
                  //                   0.3,
                  //                 ),
                  //                 width: 1.5,
                  //               ),
                  //             ),
                  //             child: Icon(
                  //               Icons.flag,
                  //               size: isTablet ? 40.0 : 32.0,
                  //               color: GoalsColors.primaryColor,
                  //             ),
                  //           ),
                  //           SizedBox(width: isTablet ? 20.0 : 16.0),
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Text(
                  //                   '🎯 Mes Objectifs',
                  //                   style: TextStyle(
                  //                     fontSize: isTablet ? 32.0 : 28.0,
                  //                     fontWeight: FontWeight.w600,
                  //                     color: GoalsColors.darkColor,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(height: 4),
                  //                 Text(
                  //                   'Définissez et suivez vos objectifs personnels',
                  //                   style: TextStyle(
                  //                     fontSize: isTablet ? 18.0 : 16.0,
                  //                     color: GoalsColors.darkColor.withOpacity(
                  //                       0.7,
                  //                     ),
                  //                     fontWeight: FontWeight.w500,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(height: isTablet ? 24.0 : 20.0),

                  //       // Statistiques des objectifs
                  //       Consumer<GoalService>(
                  //         builder: (context, goalService, child) {
                  //           final totalGoals = goalService.goals.length;
                  //           final activeGoals = goalService.goals
                  //               .where((g) => g.isActive)
                  //               .length;
                  //           final completedGoals =
                  //               goalService.completedGoals.length;

                  //           return Row(
                  //             children: [
                  //               Expanded(
                  //                 child: _buildStatCard(
                  //                   'Total',
                  //                   '$totalGoals',
                  //                   Icons.list,
                  //                   GoalsColors.primaryColor,
                  //                   isTablet,
                  //                 ),
                  //               ),
                  //               SizedBox(width: isTablet ? 20.0 : 16.0),
                  //               Expanded(
                  //                 child: _buildStatCard(
                  //                   'Actifs',
                  //                   '$activeGoals',
                  //                   Icons.play_circle,
                  //                   GoalsColors.primaryColor,
                  //                   isTablet,
                  //                 ),
                  //               ),
                  //               SizedBox(width: isTablet ? 20.0 : 16.0),
                  //               Expanded(
                  //                 child: _buildStatCard(
                  //                   'Complétés',
                  //                   '$completedGoals',
                  //                   Icons.check_circle,
                  //                   GoalsColors.primaryColor,
                  //                   isTablet,
                  //                 ),
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: isTablet ? 24.0 : 20.0),

                  // Onglets stylisés
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: padding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        isTablet ? 20.0 : 16.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey[600],
                      indicatorColor: Colors.blue,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 18.0 : 16.0,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: isTablet ? 18.0 : 16.0,
                      ),
                      tabs: const [
                        Tab(icon: Icon(Icons.play_circle), text: 'Actifs'),
                        Tab(icon: Icon(Icons.check_circle), text: 'Complétés'),
                        Tab(icon: Icon(Icons.archive), text: 'Archivés'),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 24.0 : 20.0),

                  // Contenu des onglets
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Onglet Objectifs Actifs
                        _buildGoalsList(
                          context,
                          (goalService) => goalService.goals
                              .where((g) => g.isActive)
                              .toList(),
                          'Aucun objectif actif',
                          'Commencez par créer votre premier objectif !',
                          Icons.flag_outlined,
                          isTablet,
                        ),

                        // Onglet Objectifs Complétés
                        _buildGoalsList(
                          context,
                          (goalService) => goalService.completedGoals,
                          'Aucun objectif complété',
                          'Complétez vos objectifs pour les voir ici !',
                          Icons.check_circle_outline,
                          isTablet,
                        ),

                        // Onglet Objectifs Archivés
                        _buildGoalsList(
                          context,
                          (goalService) => goalService.goals
                              .where((g) => !g.isActive && !g.isCompleted)
                              .toList(),
                          'Aucun objectif archivé',
                          'Archivez vos objectifs pour les organiser !',
                          Icons.archive_outlined,
                          isTablet,
                        ),
                      ],
                    ),
                  ),
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
                Icon(
                  emptyIcon,
                  size: isTablet ? 100.0 : 80.0,
                  color: Colors.grey[400],
                ),
                SizedBox(height: isTablet ? 32.0 : 24.0),
                Text(
                  emptyTitle,
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
                if (goalsSelector ==
                    (goalService) => goalService.goals
                        .where((g) => g.isActive)
                        .toList()) ...[
                  SizedBox(height: isTablet ? 32.0 : 24.0),
                  ElevatedButton.icon(
                    onPressed: () => _showAddGoalBottomSheet(context),
                    icon: Icon(Icons.add, size: isTablet ? 24.0 : 20.0),
                    label: Text(
                      'Créer un objectif',
                      style: TextStyle(
                        fontSize: isTablet ? 18.0 : 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32.0 : 24.0,
                        vertical: isTablet ? 20.0 : 16.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isTablet ? 20.0 : 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
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
                onTap: () => _showGoalDetails(context, goal),
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

  void _showAddGoalBottomSheet(BuildContext context, {Goal? goal}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddGoalBottomSheet(goal: goal),
    );
  }

  void _showGoalDetails(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(goal.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${goal.description}'),
            const SizedBox(height: 8),
            Text('Objectif: ${goal.targetDays} jours'),
            const SizedBox(height: 8),
            Text('Progression: ${goal.totalDays}/${goal.targetDays} jours'),
            const SizedBox(height: 8),
            Text('Grade actuel: ${goal.currentGrade.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context, Goal goal) {
    _showAddGoalBottomSheet(context, goal: goal);
  }

  void _showDeleteConfirmation(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer l\'objectif "${goal.title}" ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              context.read<GoalService>().deleteGoal(goal.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _toggleGoalStatus(Goal goal) {
    if (goal.isActive) {
      // Désactiver l'objectif en supprimant son statut actif
      final goalService = context.read<GoalService>();
      // Créer une copie de l'objectif sans le statut actif
      final updatedGoal = goal.copyWith(isActive: false);
      goalService.updateGoal(updatedGoal);
    } else {
      // Activer l'objectif
      context.read<GoalService>().activateGoal(goal.id);
    }
  }
}
