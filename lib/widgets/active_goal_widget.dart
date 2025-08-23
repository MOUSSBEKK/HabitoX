import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../services/badge_sync_service.dart';
import '../services/user_profile_service.dart';

class ActiveGoalWidget extends StatelessWidget {
  final Function(int)? onSwitchTab;

  const ActiveGoalWidget({super.key, this.onSwitchTab});

  // Couleurs du design épuré (cohérentes avec le thème global)
  static const Color primaryColor = Color(
    0xFFA7C6A5,
  ); // Vert clair pour onglets/boutons
  static const Color lightColor = Color(0xFF85B8CB); // Bleu clair pour fonds
  static const Color darkColor = Color(
    0xFF1F4843,
  ); // Vert foncé pour TOUT le texte

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
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: lightColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: lightColor.withOpacity(0.5), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.flag_outlined, size: 48, color: primaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun objectif actif',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Commencez par créer votre premier objectif pour commencer votre voyage !',
            style: TextStyle(
              fontSize: 16,
              color: darkColor.withOpacity(0.7),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              if (onSwitchTab != null) {
                onSwitchTab!(1);
              }
            },
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Créer un objectif',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: primaryColor.withOpacity(0.3),
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
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: lightColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: lightColor.withOpacity(0.4), width: 1),
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
                  color: primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(goal.icon, size: 28, color: primaryColor),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: darkColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: darkColor.withOpacity(0.7),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Grade actuel avec progression
          _buildGradeSection(goal),

          const SizedBox(height: 32),

          // Barre de progression principale
          _buildMainProgressSection(goal),

          const SizedBox(height: 32),

          // Statistiques
          _buildStatsSection(goal),

          const SizedBox(height: 32),

          // Message de motivation
          _buildMotivationSection(goal),

          const SizedBox(height: 32),

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
            Text(currentGrade.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Text(
              currentGrade.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            if (nextGrade != null) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: lightColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Prochain: ${nextGrade.emoji} ${nextGrade.title}',
                  style: TextStyle(
                    fontSize: 13,
                    color: darkColor.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (nextGrade != null) ...[
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: goal.progressToNextGrade,
            minHeight: 8,
            backgroundColor: lightColor.withOpacity(0.3),
            color: primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${(goal.progressToNextGrade * 100).toInt()}% vers ${nextGrade.title}',
            style: TextStyle(
              fontSize: 13,
              color: darkColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
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
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: darkColor,
              ),
            ),
            Text(
              '${(goal.progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: goal.progress,
          minHeight: 14,
          backgroundColor: lightColor.withOpacity(0.3),
          color: primaryColor,
          borderRadius: BorderRadius.circular(7),
        ),
        const SizedBox(height: 12),
        Text(
          '${goal.totalDays} jours sur ${goal.targetDays}',
          style: TextStyle(
            fontSize: 15,
            color: darkColor.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
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
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Meilleure série',
            '${goal.maxStreak}',
            Icons.emoji_events,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total',
            '${goal.totalDays}',
            Icons.calendar_today,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightColor.withOpacity(0.5), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: darkColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: darkColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationSection(Goal goal) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lightbulb_outline, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              goal.motivationMessage,
              style: TextStyle(
                fontSize: 16,
                color: darkColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                height: 1.4,
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
              BadgeSyncService.checkAndUnlockBadges(context);
              final profileService = context.read<UserProfileService>();
              goalService.updateAura(profileService);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Session marquée comme complétée ! +100 Aura'),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  action: SnackBarAction(
                    label: 'Annuler',
                    textColor: lightColor,
                    onPressed: () {
                      // Logique pour annuler la session
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.check, size: 20),
            label: const Text(
              'Marquer session',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: primaryColor.withOpacity(0.3),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              goalService.resetStreak(goal.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Série réinitialisée'),
                  backgroundColor: darkColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'Reset série',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: darkColor,
              side: BorderSide(color: darkColor.withOpacity(0.3), width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
