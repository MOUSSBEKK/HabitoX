import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goal.dart';
import '../services/goal_service.dart';
import '../constants/app_colors.dart';

class GlobalStatsWidget extends StatelessWidget {
  const GlobalStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalService>(
      builder: (context, goalService, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de la section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                'Vos Statistiques Globales',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkColor,
                ),
              ),
            ),

            // Statistiques principales
            _buildMainStats(goalService),

            const SizedBox(height: 24),

            // Grade le plus élevé
            _buildHighestGradeCard(goalService),

            const SizedBox(height: 24),

            // Objectifs complétés
            _buildCompletedGoalsSection(goalService),
          ],
        );
      },
    );
  }

  Widget _buildMainStats(GoalService goalService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Objectifs complétés',
              '${goalService.totalCompletedGoals}',
              Icons.flag,
              AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Jours totaux',
              '${goalService.totalDaysAcrossAllGoals}',
              Icons.calendar_today,
              AppColors.lightColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Meilleure série',
              '${goalService.bestStreakEver}',
              Icons.local_fire_department,
              AppColors.primaryColor,
            ),
          ),
        ],
      ),
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHighestGradeCard(GoalService goalService) {
    final highestGrade = goalService.highestGradeAchieved;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor.withOpacity(0.2),
              AppColors.primaryColor.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                highestGrade.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grade le plus élevé',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    highestGrade.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${highestGrade.minDays}+ jours d\'expérience',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedGoalsSection(GoalService goalService) {
    final completedGoals = goalService.completedGoals;

    if (completedGoals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.lightColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightColor.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 56,
                color: AppColors.lightColor,
              ),
              const SizedBox(height: 20),
              Text(
                'Aucun objectif complété',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Complétez votre premier objectif pour commencer votre collection de trophées !',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.darkColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(
            'Objectifs Complétés (${completedGoals.length})',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkColor,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: completedGoals.length,
            itemBuilder: (context, index) {
              final goal = completedGoals[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          goal.icon,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            goal.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complété le ${_formatDate(goal.completedAt!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          goal.currentGrade.title,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${goal.totalDays} jours',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.darkColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
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
