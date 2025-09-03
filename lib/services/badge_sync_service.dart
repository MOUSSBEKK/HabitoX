import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
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
    showOkAlertDialog(
      context: context,
      title: '🎉 Badge Débloqué ! 🎉',
      message: 'Félicitations ! Vous avez débloqué le badge :\n\n'
               '${shape.emoji} ${shape.name} Maître\n\n'
               'Calendrier ${shape.name} complété à 100% !',
      okLabel: 'Continuer',
    );
  }
}
