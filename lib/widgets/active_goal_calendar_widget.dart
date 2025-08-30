import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calendar_shape.dart';
import '../services/calendar_service.dart';
import '../services/goal_service.dart';
import '../services/badge_sync_service.dart';
import '../services/user_profile_service.dart';

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
            currentShape.totalDays != activeGoal.targetDays) {
          calendarService.ensureShapeForTargetDays(activeGoal.targetDays);
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[200]!),
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
            color: primaryColor.withOpacity(0.15),
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
    );
  }

  Widget _buildCalendarSection(
    CalendarShape shape,
    dynamic activeGoal,
    CalendarService calendarService,
  ) {
    final progress = activeGoal != null ? activeGoal.totalDays : 0;
    final maxDays = shape.totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progression du calendrier',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCalendarMatrix(shape, progress, maxDays),
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

  Widget _buildCalendarMatrix(CalendarShape shape, int progress, int maxDays) {
    final daysCompleted = progress;
    final daysToShow = shape.pattern;

    return Column(
      children: [
        const SizedBox(height: 4),
        ...daysToShow.asMap().entries.map((entry) {
          final weekIndex = entry.key;
          final week = entry.value;

          return Row(
            children: [
              ...week.asMap().entries.map((dayEntry) {
                final dayIndex = dayEntry.key;
                final shouldShow = dayEntry.value;

                if (!shouldShow) {
                  return Expanded(
                    child: Container(
                      height: 20,
                      margin: const EdgeInsets.all(1),
                    ),
                  );
                }

                final dayNumber = weekIndex * 7 + dayIndex + 1;
                final isVisibleCell = shouldShow && dayNumber <= maxDays;
                final isCompleted = isVisibleCell && dayNumber <= daysCompleted;

                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: 14,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? shape.color
                          : isVisibleCell
                          ? shape.color.withOpacity(0.25)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
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
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                'Objectif actif',
                activeGoal?.title ?? 'Aucun',
                Icons.flag,
                activeGoal?.color ?? Colors.grey,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
            style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
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
            : () {
                goalService.updateProgress(goal.id);
                BadgeSyncService.checkAndUnlockBadges(context);
                final profileService = context.read<UserProfileService>();
                goalService.updateAura(profileService);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Session marquée comme complétée ! +100 Aura',
                    ),
                    backgroundColor: primaryColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildNoActiveGoal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
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

  Widget _buildEmptyCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
