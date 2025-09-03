import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import '../models/badge.dart' as models;
import '../services/calendar_service.dart';

class BadgesWidget extends StatelessWidget {
  const BadgesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarService>(
      builder: (context, calendarService, child) {
        final unlockedBadges = calendarService.unlockedBadges;
        final lockedBadges = calendarService.lockedBadges;

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
                _buildHeader(
                  unlockedBadges.length,
                  calendarService.totalShapes,
                ),
                const SizedBox(height: 20),
                if (unlockedBadges.isNotEmpty) ...[
                  _buildUnlockedBadges(unlockedBadges),
                  const SizedBox(height: 20),
                ],
                _buildLockedBadges(lockedBadges),
                const SizedBox(height: 20),
                _buildActions(context, calendarService),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int unlockedCount, int totalShapes) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.emoji_events, size: 24, color: Colors.amber),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Collection de Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '$unlockedCount / $totalShapes badges débloqués',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Text(
            '${((unlockedCount / totalShapes) * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.amber,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnlockedBadges(List<models.Badge> badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Badges Débloqués',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return _buildBadgeCard(badge, true);
          },
        ),
      ],
    );
  }

  Widget _buildLockedBadges(List<models.Badge> badges) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Badges à Débloquer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            return _buildBadgeCard(badge, false);
          },
        ),
      ],
    );
  }

  Widget _buildBadgeCard(models.Badge badge, bool isUnlocked) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked
            ? badge.color.withValues(alpha: 0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? badge.color.withValues(alpha: 0.3)
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? badge.color.withValues(alpha: 0.2)
                  : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Text(
              badge.emoji,
              style: TextStyle(
                fontSize: 24,
                color: isUnlocked ? badge.color : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? badge.color : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (isUnlocked) ...[
            Text(
              'Débloqué',
              style: TextStyle(
                fontSize: 10,
                color: Colors.green[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else ...[
            Text(
              'Verrouillé',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, CalendarService calendarService) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showBadgeDetails(context, calendarService),
            icon: const Icon(Icons.info_outline),
            label: const Text('Détails des badges'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showResetConfirmation(context, calendarService),
            icon: const Icon(Icons.refresh),
            label: const Text('Reset progression'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showBadgeDetails(
    BuildContext context,
    CalendarService calendarService,
  ) {
    final badgesInfo = calendarService.shapes.map((shape) => 
      '${shape.emoji} ${shape.name}: ${shape.totalDays} jours ${shape.isUnlocked ? "✓" : "🔒"}'
    ).join('\n');
    
    showOkAlertDialog(
      context: context,
      title: 'Détails des Badges',
      message: 'Comment débloquer les badges :\n\n'
               '• Chaque forme de calendrier a un nombre spécifique de jours à compléter\n'
               '• Complétez votre objectif actif pour progresser dans le calendrier\n'
               '• Atteignez 100% de progression pour débloquer le badge\n'
               '• Les badges sont basés sur les formes de calendrier générées aléatoirement\n\n'
               'Badges disponibles :\n$badgesInfo',
    );
  }

  void _showResetConfirmation(
    BuildContext context,
    CalendarService calendarService,
  ) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Reset de la progression',
      message: 'Êtes-vous sûr de vouloir réinitialiser toute la progression ?\n\n'
               'Cela supprimera tous les badges débloqués et remettra toutes les formes '
               'de calendrier en mode verrouillé.\n\n'
               'Cette action est irréversible.',
      okLabel: 'Reset',
      cancelLabel: 'Annuler',
      isDestructiveAction: true,
    );
    
    if (result == OkCancelResult.ok) {
      calendarService.resetProgress();
      toastification.show(
        context: context,
        title: const Text('Progression réinitialisée'),
        type: ToastificationType.warning,
        style: ToastificationStyle.flatColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }
}
