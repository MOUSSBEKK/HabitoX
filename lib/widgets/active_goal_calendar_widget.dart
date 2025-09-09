import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../models/calendar_shape.dart';
import '../services/calendar_service.dart';
import '../services/goal_service.dart';
import '../services/user_profile_service.dart';
import '../services/home_widget_service.dart';
import '../constants/app_colors.dart';
import 'level_up_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ActiveGoalCalendarWidget extends StatelessWidget {
  final Function(int)? onSwitchTab;

  const ActiveGoalCalendarWidget({super.key, this.onSwitchTab});

  static const Color primaryColor = Color(0xFFA7C6A5);
  static const Color lightColor = Color(0xFF85B8CB);
  static const Color darkColor = Color(0xFF1F4843);

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoalService, CalendarService>(
      builder: (context, goalService, calendarService, child) {
        final activeGoal = goalService.activeGoal;

        if (activeGoal == null) {
          return _buildNoActiveGoal(context);
        }

        final currentShape = calendarService.currentShape;
        if (currentShape == null ||
            currentShape.totalDays != activeGoal.targetDays ||
            currentShape.color != activeGoal.color) {
          calendarService.ensureShapeForTargetDays(
            activeGoal.targetDays,
            goalColor: activeGoal.color,
          );
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                activeGoal.icon,
                activeGoal.title,
                activeGoal.description,
              ),
              const SizedBox(height: 24),
              if (calendarService.currentShape != null)
                _buildCalendarSection(
                  calendarService.currentShape!,
                  activeGoal,
                  calendarService,
                  context,
                )
              else
                _buildEmptyCalendarCard(),
              const SizedBox(height: 20),
              if (calendarService.currentShape != null)
                _buildProgressInfo(calendarService.currentShape!, activeGoal),
              const SizedBox(height: 24),
              _buildMarkSessionButton(context, goalService, activeGoal),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(
              255,
              48,
              83,
              45,
            ).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 28, color: primaryColor),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: darkColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: darkColor.withValues(alpha: 0.7),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection(
    CalendarShape shape,
    dynamic activeGoal,
    CalendarService calendarService,
    BuildContext context,
  ) {
    final progress = activeGoal != null ? activeGoal.totalDays : 0;
    final maxDays = shape.totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calendar progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeatMap(context, shape, activeGoal),
              const SizedBox(height: 8),
              Text(
                '$progress / $maxDays jours complétés',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Construit la heatmap type GitHub à partir des sessions réalisées
  Widget _buildHeatMap(
    BuildContext context,
    CalendarShape shape,
    dynamic activeGoal,
  ) {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 90));

    // Agréger les sessions par jour et calculer une valeur de streak pour l'intensité
    final Map<DateTime, int> rawCounts = {};
    for (final session in activeGoal.completedSessions) {
      final day = DateTime(session.year, session.month, session.day);
      if (day.isBefore(start) || day.isAfter(now)) continue;
      rawCounts.update(day, (v) => v + 1, ifAbsent: () => 1);
    }

    // Calcul d'une intensité basée sur le streak jusqu'à chaque date
    final sortedDays = rawCounts.keys.toList()..sort();
    final Map<DateTime, int> datasets = {};
    DateTime? previousDay;
    int currentStreak = 0;
    for (final day in sortedDays) {
      if (previousDay != null && day.difference(previousDay).inDays == 1) {
        currentStreak += 1;
      } else {
        currentStreak = 1;
      }
      previousDay = day;
      // Limiter l'intensité pour correspondre aux paliers de couleurs
      datasets[day] = currentStreak.clamp(1, 7);
    }

    final base = shape.color;
    final colorsets = <int, Color>{
      1: base.withValues(alpha: 0.25),
      2: base.withValues(alpha: 0.35),
      3: base.withValues(alpha: 0.45),
      4: base.withValues(alpha: 0.60),
      5: base.withValues(alpha: 0.70),
      6: base.withValues(alpha: 0.85),
      7: base,
    };

    return HeatMapCalendar(
      size: 35,
      margin: const EdgeInsets.all(2),
      fontSize: 14,
      showColorTip: false,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.grey[700],
      datasets: datasets,
      colorsets: colorsets,
      // enlever le onclick
      onClick: (selectedDay) async {
        final today = DateTime(now.year, now.month, now.day);
        if (selectedDay == today) {
          final goalService = context.read<GoalService>();
          final profileService = context.read<UserProfileService>();

          // Vérifier si déjà marqué aujourd'hui
          final already = activeGoal.completedSessions.any(
            (d) => DateTime(d.year, d.month, d.day) == today,
          );
          if (!already) {
            final update = await goalService.updateProgress(
              activeGoal.id,
              profileService,
            );
            if (update != null) {
              toastification.show(
                context: context,
                title: const Text('Session marquée !'),
                description: const Text('+2 XP'),
                type: ToastificationType.success,
                style: ToastificationStyle.flatColored,
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          }
        }
      },
    );
  }

  Widget _buildProgressInfo(CalendarShape shape, dynamic activeGoal) {
    final progress = activeGoal != null ? activeGoal.totalDays : 0;
    final maxDays = shape.totalDays;
    final remainingDays = maxDays - progress;
    final isCompleted = progress >= maxDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informations',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Jours restants',
                remainingDays.toString(),
                Icons.calendar_today,
                isCompleted ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Progression',
                '${((progress / maxDays) * 100).clamp(0, 100).toInt()}%',
                Icons.trending_up,
                shape.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMarkSessionButton(
    BuildContext context,
    GoalService goalService,
    dynamic goal,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final alreadyCompletedToday = goal.completedSessions.any(
      (session) => DateTime(session.year, session.month, session.day) == today,
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: alreadyCompletedToday
            ? null
            : () async {
                final profileService = context.read<UserProfileService>();

                // Utiliser le nouveau système XP
                final levelUpResult = await profileService.addExperience(
                  2,
                ); // XP pour session quotidienne

                // Afficher animation XP
                if (context.mounted) {
                  // Pour l'instant, on ne fait qu'un print, on ajoutera l'animation plus tard
                  print('Gained 2 XP!');
                }

                // Si level up, afficher popup
                // if (levelUpResult != null &&
                //     levelUpResult.hasLeveledUp &&
                //     context.mounted) {
                //   final badgeAsset =
                //       'assets/badges/BADGE${levelUpResult.newLevel}.png';
                //   final badgeName =
                //       profileService.userProfile?.levelName ??
                //       'Niveau ${levelUpResult.newLevel}';
                //   final badgeDescription =
                //       'Congratulations ! You have reached level ${levelUpResult.newLevel} !';

                //   showDialog(
                //     context: context,
                //     barrierDismissible: true,
                //     builder: (context) => LevelUpDialog(
                //       levelUpResult: levelUpResult,
                //       badgeAssetPath: badgeAsset,
                //       badgeName: badgeName,
                //       badgeDescription: badgeDescription,
                //     ),
                //   );
                // }

                final updateResult = await goalService.updateProgress(
                  goal.id,
                  profileService,
                );
                // BadgeSyncService.checkAndUnlockBadges(context);

                // Afficher le toast approprié selon le résultat
                if (updateResult != null) {
                  if (updateResult['goalCompleted'] == true) {
                    // Objectif terminé complètement
                    final xpGained = updateResult['xpGained'] as int? ?? 0;
                    final levelUpResult = updateResult['levelUpResult'];

                    toastification.show(
                      context: context,
                      title: const Text('🎉 Goal Completed !'),
                      description: Text('Congratulations ! +$xpGained XP'),
                      type: ToastificationType.success,
                      style: ToastificationStyle.flatColored,
                      autoCloseDuration: const Duration(seconds: 4),
                    );

                    // Si level up, afficher popup
                    if (levelUpResult != null &&
                        levelUpResult.hasLeveledUp &&
                        context.mounted) {
                      final badgeAsset =
                          'assets/badges/BADGE${levelUpResult.newLevel}.png';
                      final badgeName =
                          profileService.userProfile?.levelName ??
                          'Niveau ${levelUpResult.newLevel}';

                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => LevelUpDialog(
                          levelUpResult: levelUpResult,
                          badgeAssetPath: badgeAsset,
                          badgeName: badgeName,
                          badgeDescription: 'You have reached a new level !',
                        ),
                      );
                    }
                  } else {
                    // Session normale
                    toastification.show(
                      context: context,
                      title: const Text('Session marquée comme complétée !'),
                      description: const Text('+2 XP'),
                      type: ToastificationType.success,
                      style: ToastificationStyle.flatColored,
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  }
                }

                // Mettre à jour le widget d'accueil après toute progression
                final calendarService = context.read<CalendarService>();
                await HomeWidgetService.updateActiveGoalHeatmap(
                  context,
                  goalService,
                  calendarService,
                );
              },
        icon: Icon(
          Icons.check,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        label: Text(
          'Marquer session',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          shadowColor: const Color.fromARGB(
            255,
            38,
            217,
            25,
          ).withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildNoActiveGoal(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône moderne avec style épuré
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.flag,
                size: 40,
                color: AppColors.lightColor.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Titre principal
          Text(
            'No active goal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Sous-titre explicatif
          Text(
            'Create your first goal to\nstart your journey',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_month, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Chargement du calendrier...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
