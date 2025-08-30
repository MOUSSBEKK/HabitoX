import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'goal_service.dart';
import 'calendar_service.dart';
import '../models/calendar_shape.dart';

class BadgeSyncService {
  static void checkAndUnlockBadges(BuildContext context) {
    final goalService = Provider.of<GoalService>(context, listen: false);
    final calendarService = Provider.of<CalendarService>(
      context,
      listen: false,
    );

    // Check each shape to see if it should be unlocked
    for (final shape in calendarService.shapes) {
      if (!shape.isUnlocked && goalService.shouldUnlockCalendarShape(shape)) {
        // Unlock the badge for this shape
        calendarService.unlockBadge(shape);

        // Show a celebration dialog
        _showBadgeUnlockedDialog(context, shape);
      }
    }
  }

  static void _showBadgeUnlockedDialog(
    BuildContext context,
    CalendarShape shape,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: shape.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(shape.emoji, style: const TextStyle(fontSize: 60)),
            ),
            const SizedBox(height: 20),
            Text(
              '🎉 Badge Débloqué ! 🎉',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: shape.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Félicitations ! Vous avez débloqué le badge :',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${shape.name} Maître',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: shape.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Calendrier ${shape.name} complété à 100% !',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: shape.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Continuer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
