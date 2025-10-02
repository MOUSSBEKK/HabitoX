import 'dart:math';
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
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

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

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final isSmallScreen = screenWidth < 360;
            final isTablet = screenWidth > 600;

            // Padding adaptatif
            final padding = isSmallScreen ? 16.0 : (isTablet ? 32.0 : 24.0);

            return Container(
              padding: EdgeInsets.all(padding),
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
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  _buildCalendarSection(
                    calendarService.currentShape!,
                    activeGoal,
                    calendarService,
                    context,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  _buildMarkSessionButton(context, goalService, activeGoal),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(
    IconData icon,
    String title,
    String description,
    CalendarShape shape,
    BuildContext context, {
    bool isSmallScreen = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: shape.color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: isSmallScreen ? 24 : 28, color: shape.color),
        ),
        SizedBox(width: isSmallScreen ? 16 : 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isSmallScreen ? 2 : 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 15,
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
    // Données factices pour le progrès
    final random = Random();
    final progress =
        random.nextInt(shape.totalDays ~/ 2) +
        (shape.totalDays ~/ 3); // Entre 1/3 et 5/6 du total
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

  // Construit la heatmap type GitHub à partir des sessions réalisées et des jours futurs à compléter
  Widget _buildHeatMap(
    BuildContext context,
    CalendarShape shape,
    dynamic activeGoal,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculer la taille adaptative du calendrier
        final screenWidth = MediaQuery.sizeOf(context).width;
        final availableWidth = constraints.maxWidth;

        // Déterminer la taille des cellules en fonction de l'espace disponible
        double cellSize;
        double fontSize;
        double monthFontSize;
        double weekFontSize;

        if (screenWidth < 360) {
          // Très petits écrans (comme l'iPhone SE)
          cellSize = 28;
          fontSize = 10;
          monthFontSize = 12;
          weekFontSize = 10;
        } else if (screenWidth < 400) {
          // Petits écrans
          cellSize = 32;
          fontSize = 11;
          monthFontSize = 14;
          weekFontSize = 11;
        } else if (screenWidth < 600) {
          // Écrans moyens
          cellSize = 40;
          fontSize = 12;
          monthFontSize = 15;
          weekFontSize = 12;
        } else {
          // Grands écrans et tablettes
          cellSize = 39;
          fontSize = 14;
          monthFontSize = 16;
          weekFontSize = 14;
        }

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, 1);
        final start = now.subtract(const Duration(days: 90));

        final Map<DateTime, int> datasets = {};

        // Données factices pour la heatmap
        final random = Random();

        // Générer des données pour les 90 derniers jours (intensité faible à moyenne)

        // Ajouter des jours futurs avec intensité maximale (7)
        for (int i = 1; i <= 30; i++) {
          final futureDay = today.add(Duration(days: i));
          // 40% de chance d'avoir une intensité maximale pour les jours futurs
          datasets[futureDay] = 1; // intensité maximale pour les jours futurs
        }

        for (int i = 0; i < 30; i++) {
          final day = today.add(Duration(days: i));
          // if (day.isAfter(now)) continue;
          debugPrint('day: $day');
          // 60% de chance d'avoir une activité ce jour-là
          if (random.nextDouble() < 0.6) {
            // Niveau d'intensité aléatoire entre 1 et 5 pour les jours passés
            datasets[day] = 6;
          }
        }

        final base = shape.color;
        final colorsets = <int, Color>{
          1: base.withValues(
            alpha: 0.15,
          ), // Opacité très faible pour les jours futurs
          2: base.withValues(alpha: 0.35),
          3: base.withValues(alpha: 0.45),
          4: base.withValues(alpha: 0.60),
          5: base.withValues(alpha: 0.70),
          6: base.withValues(alpha: 0.85),
          7: base, // Intensité maximale pour les jours complétés
        };

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: availableWidth),
            child: HeatMapCalendar(
              size: cellSize,
              fontSize: fontSize,
              monthFontSize: monthFontSize,
              weekFontSize: weekFontSize,
              showColorTip: false,
              colorMode: ColorMode.color,
              defaultColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).textTheme.bodyMedium?.color,
              weekTextColor: Color(0xFFA7C6A5),
              datasets: datasets,
              colorsets: colorsets,
            ),
          ),
        );
      },
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
                final int experience = 5;
                // Utiliser le nouveau système XP
                await profileService.addExperience(experience);

                final updateResult = await goalService.updateProgress(
                  goal.id,
                  profileService,
                );
                if (updateResult != null) {
                  if (updateResult['goalCompleted'] == true) {
                    // Objectif terminé complètement
                    final xpGained = updateResult['xpGained'] as int? ?? 0;
                    final levelUpResult = updateResult['levelUpResult'];

                    toastification.show(
                      context: context,
                      title: Text(
                        AppLocalizations.of(
                          context,
                        )!.toastification_goal_completed,
                      ),
                      description: Text('Congratulations ! +$xpGained XP'),
                      type: ToastificationType.success,
                      style: ToastificationStyle.flat,
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
                      title: Text(
                        AppLocalizations.of(
                          context,
                        )!.toastification_session_completed,
                      ),
                      description: Text('+${experience} XP'),
                      type: ToastificationType.success,
                      style: ToastificationStyle.simple,
                      autoCloseDuration: const Duration(seconds: 3),
                      closeOnClick: false,
                    );
                  }
                }

                // Mettre à jour le widget d'accueil après toute progression
                await HomeWidgetService.updateActiveGoalHeatmap(
                  context,
                  goalService,
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
              child: Icon(
                HugeIconsStroke.flag02,
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
}
