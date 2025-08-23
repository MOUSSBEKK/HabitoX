import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../services/badge_sync_service.dart';

class ActiveGoalWidget extends StatelessWidget {
  const ActiveGoalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalService>(
      builder: (context, goalService, child) {
        final activeGoal = goalService.activeGoal;

        if (activeGoal == null) {
          return _buildNoActiveGoal(context);
        }

        return _buildActiveGoal(context, activeGoal, goalService);
      },
    );
  }

  Widget _buildNoActiveGoal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.flag_outlined, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucun objectif actif',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par créer votre premier objectif pour commencer votre voyage !',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Navigation vers la création d'objectif
              Navigator.pushNamed(context, '/goals');
            },
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

  Widget _buildActiveGoal(
    BuildContext context,
    Goal goal,
    GoalService goalService,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [goal.color.withOpacity(0.1), goal.color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: goal.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: goal.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(goal.icon, size: 32, color: goal.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goal.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Grade actuel avec progression
          _buildGradeSection(goal),

          const SizedBox(height: 24),

          // Barre de progression principale
          _buildMainProgressSection(goal),

          const SizedBox(height: 24),

          // Statistiques
          _buildStatsSection(goal),

          const SizedBox(height: 24),

          // Message de motivation
          _buildMotivationSection(goal),

          const SizedBox(height: 24),

          // Actions
          _buildActionsSection(context, goal, goalService),
        ],
      ),
    );
  }

  Widget _buildGradeSection(Goal goal) {
    final currentGrade = goal.currentGrade;
    final nextGrade = goal.nextGrade;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(currentGrade.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              currentGrade.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: currentGrade.color,
              ),
            ),
            if (nextGrade != null) ...[
              const Spacer(),
              Text(
                'Prochain: ${nextGrade.emoji} ${nextGrade.title}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        if (nextGrade != null) ...[
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: goal.progressToNextGrade,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            color: currentGrade.color,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 4),
          Text(
            '${(goal.progressToNextGrade * 100).toInt()}% vers ${nextGrade.title}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildMainProgressSection(Goal goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progression vers l\'objectif',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${(goal.progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: goal.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: goal.progress,
          minHeight: 12,
          backgroundColor: Colors.grey[300],
          color: goal.color,
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 8),
        Text(
          '${goal.totalDays} jours sur ${goal.targetDays}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatsSection(Goal goal) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Série actuelle',
            '${goal.currentStreak}',
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Meilleure série',
            '${goal.maxStreak}',
            Icons.emoji_events,
            Colors.amber,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total',
            '${goal.totalDays}',
            Icons.calendar_today,
            Colors.blue,
          ),
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
          Icon(icon, color: color, size: 20),
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

  Widget _buildMotivationSection(Goal goal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              goal.motivationMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.amber[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    Goal goal,
    GoalService goalService,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              goalService.updateProgress(goal.id);

              // Check if any badges should be unlocked
              BadgeSyncService.checkAndUnlockBadges(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Session marquée comme complétée !'),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                    label: 'Annuler',
                    onPressed: () {
                      // Logique pour annuler la session
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Marquer session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              goalService.resetStreak(goal.id);
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
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
