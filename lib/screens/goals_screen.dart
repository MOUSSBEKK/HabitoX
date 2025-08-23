import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../widgets/goal_card.dart';
import '../widgets/add_goal_dialog.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestion des Objectifs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.indigo,
      ),
      body: Consumer<GoalService>(
        builder: (context, goalService, child) {
          final allGoals = goalService.goals;
          final activeGoal = goalService.activeGoal;
          final completedGoals = goalService.completedGoals;
          final archivedGoals = goalService.archivedGoals;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section objectif actif
                if (activeGoal != null) ...[
                  _buildSectionTitle('🎯 Objectif Actuel', Colors.green),
                  const SizedBox(height: 16),
                  GoalCard(
                    goal: activeGoal!,
                    onTap: () => _showGoalDetails(context, activeGoal!),
                    onEdit: () => _showEditGoalDialog(context, activeGoal!),
                    onDelete: () =>
                        _showDeleteConfirmation(context, activeGoal!),
                    onToggleStatus: () =>
                        _showSwitchGoalDialog(context, goalService),
                  ),
                  const SizedBox(height: 32),
                ],

                // Section objectifs complétés
                if (completedGoals.isNotEmpty) ...[
                  _buildSectionTitle('🏆 Objectifs Complétés', Colors.amber),
                  const SizedBox(height: 16),
                  ...completedGoals.map(
                    (goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GoalCard(
                        goal: goal,
                        onTap: () => _showGoalDetails(context, goal),
                        onEdit: () => _showEditGoalDialog(context, goal),
                        onDelete: () => _showDeleteConfirmation(context, goal),
                        onToggleStatus: () => _showReactivateGoalDialog(
                          context,
                          goal,
                          goalService,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Section objectifs archivés
                if (archivedGoals.isNotEmpty) ...[
                  _buildSectionTitle('📁 Objectifs Archivés', Colors.grey),
                  const SizedBox(height: 16),
                  ...archivedGoals.map(
                    (goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GoalCard(
                        goal: goal,
                        onTap: () => _showGoalDetails(context, goal),
                        onEdit: () => _showEditGoalDialog(context, goal),
                        onDelete: () => _showDeleteConfirmation(context, goal),
                        onToggleStatus: () =>
                            _showActivateGoalDialog(context, goal, goalService),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // État vide si aucun objectif
                if (allGoals.isEmpty) ...[_buildEmptyState(context)],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouvel Objectif'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title == '🎯 Objectif Actuel'
                ? '1 seul actif'
                : '${title == '🏆 Objectifs Complétés' ? 'Complétés' : 'Archivés'}',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Aucun objectif pour le moment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Commencez par créer votre premier objectif !\n\n💡 Rappel : Vous ne pouvez traiter qu\'un seul objectif à la fois pour rester focalisé.',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showAddGoalDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Créer un objectif'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddGoalDialog());
  }

  void _showEditGoalDialog(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AddGoalDialog(goal: goal),
    );
  }

  void _showGoalDetails(BuildContext context, Goal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoalDetailsScreen(goal: goal)),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'objectif'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${goal.title}" ?\n\nCette action est irréversible.',
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

  void _showSwitchGoalDialog(BuildContext context, GoalService goalService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer d\'objectif'),
        content: const Text(
          'Voulez-vous vraiment changer d\'objectif ?\n\n'
          '⚠️ Attention : Changer d\'objectif désactivera l\'objectif actuel. '
          'Il est recommandé de terminer un objectif avant d\'en commencer un autre.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showGoalSelectionDialog(context, goalService);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Changer'),
          ),
        ],
      ),
    );
  }

  void _showGoalSelectionDialog(BuildContext context, GoalService goalService) {
    final availableGoals = goalService.goals
        .where((g) => !g.isActive && !g.isCompleted)
        .toList();

    if (availableGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucun autre objectif disponible'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir un nouvel objectif'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableGoals.length,
            itemBuilder: (context, index) {
              final goal = availableGoals[index];
              return ListTile(
                leading: Icon(goal.icon, color: goal.color),
                title: Text(goal.title),
                subtitle: Text(goal.description),
                onTap: () {
                  goalService.activateGoal(goal.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${goal.title} est maintenant votre objectif actif',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showActivateGoalDialog(
    BuildContext context,
    Goal goal,
    GoalService goalService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activer l\'objectif'),
        content: Text(
          'Voulez-vous activer "${goal.title}" ?\n\n'
          '⚠️ Attention : Cela désactivera l\'objectif actuellement actif.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              goalService.activateGoal(goal.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${goal.title} est maintenant votre objectif actif',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Activer'),
          ),
        ],
      ),
    );
  }

  void _showReactivateGoalDialog(
    BuildContext context,
    Goal goal,
    GoalService goalService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réactiver l\'objectif'),
        content: Text(
          'Voulez-vous réactiver "${goal.title}" ?\n\n'
          '⚠️ Attention : Cela désactivera l\'objectif actuellement actif.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              goalService.activateGoal(goal.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${goal.title} est maintenant votre objectif actif',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Réactiver'),
          ),
        ],
      ),
    );
  }
}

class GoalDetailsScreen extends StatelessWidget {
  final Goal goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal.title),
        backgroundColor: goal.color.withOpacity(0.1),
        foregroundColor: goal.color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec icône et titre
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: goal.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(goal.icon, size: 60, color: goal.color),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    goal.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Grade et progression
            _buildGradeSection(goal),

            const SizedBox(height: 32),

            // Statistiques
            _buildStatsSection(),

            const SizedBox(height: 32),

            // Barre de progression
            _buildProgressSection(),

            const SizedBox(height: 32),

            // Actions
            _buildActionsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSection(Goal goal) {
    final currentGrade = goal.currentGrade;
    final nextGrade = goal.nextGrade;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grade et Progression',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                currentGrade.color.withOpacity(0.2),
                currentGrade.color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: currentGrade.color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Text(currentGrade.emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentGrade.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: currentGrade.color,
                      ),
                    ),
                    Text(
                      '${currentGrade.minDays}+ jours d\'expérience',
                      style: TextStyle(
                        fontSize: 14,
                        color: currentGrade.color.withOpacity(0.8),
                      ),
                    ),
                    if (nextGrade != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Prochain: ${nextGrade.emoji} ${nextGrade.title}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Progression',
                '${(goal.progress * 100).toInt()}%',
                Icons.trending_up,
                goal.color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Série actuelle',
                '${goal.currentStreak} jours',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Meilleure série',
                '${goal.maxStreak} jours',
                Icons.emoji_events,
                Colors.amber,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progression vers l\'objectif',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: goal.progress,
          minHeight: 12,
          backgroundColor: Colors.grey[300],
          color: goal.color,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 8),
        Text(
          '${goal.totalDays} jours sur ${goal.targetDays}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    if (goal.isCompleted) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.celebration, color: Colors.green[700], size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎉 Objectif accompli !',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complété le ${_formatDate(goal.completedAt!)}',
                    style: TextStyle(fontSize: 14, color: Colors.green[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        if (goal.isActive) ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<GoalService>().updateProgress(goal.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Session marquée comme complétée !'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Marquer session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<GoalService>().resetStreak(goal.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Série réinitialisée'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset série'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: () {
              context.read<GoalService>().activateGoal(goal.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${goal.title} est maintenant votre objectif actif',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Activer cet objectif'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Aujourd\'hui';
    if (difference == 1) return 'Hier';
    if (difference < 7) return 'Il y a $difference jours';
    if (difference < 30) return 'Il y a ${(difference / 7).round()} semaines';
    if (difference < 365) return 'Il y a ${(difference / 30).round()} mois';
    return 'Il y a ${(difference / 365).round()} ans';
  }
}
