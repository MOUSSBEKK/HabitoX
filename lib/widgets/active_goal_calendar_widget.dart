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
import '../l10n/app_localizations.dart';

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
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                activeGoal.icon,
                activeGoal.title,
                activeGoal.description,
                calendarService.currentShape!,
                context,
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
                _buildEmptyCalendarCard(context),
              const SizedBox(height: 20),
              if (calendarService.currentShape != null)
                _buildProgressInfo(
                  calendarService.currentShape!,
                  activeGoal,
                  context,
                ),
              const SizedBox(height: 24),
              _buildMarkSessionButton(context, goalService, activeGoal),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    IconData icon,
    String title,
    String description,
    CalendarShape shape,
    BuildContext context,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: shape.color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 28, color: shape.color),
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
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(
                    context,
                  ).textTheme.titleLarge?.color?.withValues(alpha: 0.8),
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
          AppLocalizations.of(context)!.calendar_progress,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeatMap(context, shape, activeGoal),
              const SizedBox(height: 12),
              Text(
                '${progress} / ${maxDays} ${AppLocalizations.of(context)!.calendar_completed_days}',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
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

    // Pour chaque jour complété, appliquer directement l'intensité maximale (couleur la plus foncée)
    final Map<DateTime, int> datasets = {};
    for (final session in activeGoal.completedSessions) {
      final day = DateTime(session.year, session.month, session.day);
      if (day.isBefore(start) || day.isAfter(now)) continue;
      datasets[day] = 7; // niveau d'intensité max correspondant à colorsets
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
      size: 39,
      fontSize: 14,
      monthFontSize: 16,
      weekFontSize: 14,
      showColorTip: false,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).textTheme.bodyMedium?.color,
      weekTextColor: Color(0xFFA7C6A5),
      datasets: datasets,
      colorsets: colorsets,
    );
  }

  Widget _buildProgressInfo(
    CalendarShape shape,
    dynamic activeGoal,
    BuildContext context,
  ) {
    final progress = activeGoal != null ? activeGoal.totalDays : 0;
    final maxDays = shape.totalDays;
    final remainingDays = maxDays - progress;
    final isCompleted = progress >= maxDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.calendar_informations,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium?.color,
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
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
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
            style: TextStyle(fontSize: 10, color: color),
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
                final int experience = 2;
                // Utiliser le nouveau système XP
                await profileService.addExperience(experience);

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
                      description: Text('+${experience} XP'),
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
          AppLocalizations.of(context)!.calendar_mark_session,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA7C6A5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
              color: Color(0xFFA7C6A5).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.flag,
                size: 40,
                color: Color(0xFFA7C6A5),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Titre principal
          Text(
            AppLocalizations.of(context)!.calendar_empty_state,
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
            AppLocalizations.of(context)!.calender_empty_state_subtitle,
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

  Widget _buildEmptyCalendarCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        children: [
          Icon(Icons.calendar_month, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.calendar_loading,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
