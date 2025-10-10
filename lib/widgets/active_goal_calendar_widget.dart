import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../services/goal_service.dart';
import '../services/user_profile_service.dart';
import '../services/home_widget_service.dart';
import '../constants/app_colors.dart';
import 'level_up_dialog.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:gaimon/gaimon.dart';

class ActiveGoalCalendarWidget extends StatelessWidget {
  final Function(int)? onSwitchTab;

  const ActiveGoalCalendarWidget({super.key, this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalService>(
      builder: (context, goalService, child) {
        final activeGoal = goalService.activeGoal;

        if (activeGoal == null) {
          return _buildNoActiveGoal(context);
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.sizeOf(context).width;
            final isSmallScreen = screenWidth < 360;
            final isTablet = screenWidth > 600;

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
                    activeGoal.color,
                    context,
                    isSmallScreen: isSmallScreen,
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  _buildCalendarSection(activeGoal, context),
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
    Color color,
    BuildContext context, {
    bool isSmallScreen = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: isSmallScreen ? 24 : 28, color: color),
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

  Widget _buildCalendarSection(dynamic activeGoal, BuildContext context) {
    final progress = activeGoal != null ? activeGoal.totalDays : 0;
    final maxDays = activeGoal.targetDays;

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
              _buildHeatMap(context, activeGoal.color, activeGoal),
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

  Widget _buildHeatMap(BuildContext context, Color color, dynamic activeGoal) {
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
        final today = DateTime(now.year, now.month, now.day);
        final start = now.subtract(const Duration(days: 90));

        final Map<DateTime, int> datasets = {};

        // Créer un Set des jours complétés pour faciliter la recherche
        final completedDaysSet = <DateTime>{};
        for (final session in activeGoal.completedSessions) {
          final day = DateTime(session.year, session.month, session.day);
          if (day.isBefore(start) || day.isAfter(now)) continue;
          completedDaysSet.add(day);
          datasets[day] = 7; // niveau d'intensité max correspondant à colorsets
        }

        // Identifier les jours manqués dans la période de 90 jours
        // Un jour est manqué s'il est dans la période passée (start à today)
        // et qu'il n'a pas été complété
        var currentDay = start;
        while (currentDay.isBefore(today)) {
          if (!completedDaysSet.contains(currentDay)) {
            datasets[currentDay] = 8;
          }
          currentDay = currentDay.add(const Duration(days: 1));
        }

        // Calculer les jours restants à compléter
        final completedDays = activeGoal.completedSessions.length;
        final remainingDays = activeGoal.targetDays - completedDays;

        // Ajouter les jours futurs à compléter (intensité faible)
        if (remainingDays > 0) {
          for (int i = 0; i < remainingDays; i++) {
            final futureDay = today.add(Duration(days: i + 1));
            // Vérifier que le jour futur n'est pas déjà complété
            if (!completedDaysSet.contains(futureDay)) {
              datasets[futureDay] =
                  1; // niveau d'intensité faible pour les jours futurs
            }
          }
        }

        final base = color;
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
          8: Colors.red.withValues(
            alpha: 0.2,
          ), // Rouge avec opacité faible pour les jours manqués
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
                debugPrint('$isGaimonSupported');
                if (isGaimonSupported == true) {
                  debugPrint('Gaimon Sélection');
                  
                }
                Gaimon.success();

                final profileService = context.read<UserProfileService>();
                final int experience = 5;
                // Utiliser le nouveau système XP
                await profileService.addExperience(experience);

                final updateResult = await goalService.updateProgress(
                  goal.id,
                  profileService,
                );
                if (updateResult != null) {
                  debugPrint('goal not completed');
                  if (updateResult['goalCompleted'] != true) {
                    // Objectif terminé complètement
                  debugPrint('xp gained');

                    final xpGained = updateResult['xpGained'] as int? ?? 0;
                    final levelUpResult = updateResult['levelUpResult'];

                    // toastification.show(
                    //   context: context,
                    //   title: Text(
                    //     AppLocalizations.of(
                    //       context,
                    //     )!.toastification_goal_completed,
                    //   ),
                    //   description: Text('Congratulations ! +$xpGained XP'),
                    //   type: ToastificationType.success,
                    //   style: ToastificationStyle.flat,
                    //   autoCloseDuration: const Duration(seconds: 4),
                    // );

                    // Si level up, afficher popup
                    //if (levelUpResult != null &&
                      //  levelUpResult.hasLeveledUp &&
                        //context.mounted) {
                      final badgeAsset =
                          'assets/badges/BADGE1.png';
                      final badgeName =
                          profileService.userProfile?.levelName ??
                          'Niveau 1';

                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => LevelUpDialog(
                          //levelUpResult: levelUpResult,
                          badgeAssetPath: badgeAsset,
                          badgeName: badgeName,
                        ),
                      );
                    //}
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

          Text(
            AppLocalizations.of(context)!.calendar_empty_state,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

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

  static Future<bool> isGaimonSupported() async => Gaimon.canSupportsHaptic;
}
