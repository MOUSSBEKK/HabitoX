import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calendar_shape.dart';
import '../services/calendar_service.dart';
import '../services/goal_service.dart';

class CalendarHeatmapWidget extends StatelessWidget {
  const CalendarHeatmapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalendarService, GoalService>(
      builder: (context, calendarService, goalService, child) {
        final activeGoal = goalService.activeGoal;
        final currentShape = calendarService.currentShape;

        // Synchroniser la forme avec le nombre de jours cible de l'objectif actif
        if (activeGoal != null &&
            (currentShape == null ||
                currentShape.totalDays != activeGoal.targetDays)) {
          // Appel non bloquant; le widget sera reconstruit après notifyListeners
          calendarService.ensureShapeForTargetDays(activeGoal.targetDays);
        }

        if (currentShape == null) {
          return _buildEmptyState();
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(currentShape),
                const SizedBox(height: 20),
                _buildCalendarGrid(currentShape, activeGoal, calendarService),
                const SizedBox(height: 20),
                _buildProgressInfo(currentShape, activeGoal, calendarService),
                const SizedBox(height: 20),
                // ! boutons "nouvelle forme" et "changer forme"
                // _buildActions(context, calendarService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(CalendarShape shape) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: shape.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(shape.emoji, style: const TextStyle(fontSize: 24)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendrier ${shape.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (shape.isUnlocked)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'Débloqué',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarGrid(
    CalendarShape shape,
    dynamic activeGoal,
    CalendarService calendarService,
  ) {
    final progress = activeGoal != null ? activeGoal.totalDays : 0;
    final maxDays = shape.totalDays;
    final completionRatio = maxDays > 0
        ? (progress / maxDays).clamp(0.0, 1.0)
        : 0.0;

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
        // Calendar grid
        ...daysToShow.asMap().entries.map((entry) {
          final weekIndex = entry.key;
          final week = entry.value;

          return Row(
            children: [
              // Week days
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

  Widget _buildProgressInfo(
    CalendarShape shape,
    dynamic activeGoal,
    CalendarService calendarService,
  ) {
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

  // ! boutons "nouvelle forme" et "changer forme"
  // Widget _buildActions(BuildContext context, CalendarService calendarService) {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: OutlinedButton.icon(
  //           onPressed: () => calendarService.generateNewShape(),
  //           icon: const Icon(Icons.refresh),
  //           label: const Text('Nouvelle forme'),
  //           style: OutlinedButton.styleFrom(
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: ElevatedButton.icon(
  //           onPressed: () => _showShapeSelection(context, calendarService),
  //           icon: const Icon(Icons.grid_view),
  //           label: const Text('Changer forme'),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.indigo,
  //             foregroundColor: Colors.white,
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _showShapeSelection(
    BuildContext context,
    CalendarService calendarService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une forme de calendrier'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: calendarService.shapes.length,
            itemBuilder: (context, index) {
              final shape = calendarService.shapes[index];
              final isCurrent = calendarService.currentShape?.id == shape.id;

              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: shape.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    shape.emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                title: Text(shape.name),
                subtitle: Text('${shape.totalDays} jours'),
                trailing: isCurrent
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : shape.isUnlocked
                    ? Icon(Icons.lock_open, color: Colors.blue)
                    : Icon(Icons.lock, color: Colors.grey),
                onTap: () {
                  calendarService.setCurrentShape(shape.id);
                  Navigator.pop(context);
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

  Widget _buildEmptyState() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.calendar_month, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Aucune forme de calendrier',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Générez votre première forme de calendrier pour commencer !',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
