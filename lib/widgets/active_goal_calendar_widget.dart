import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calendar_shape.dart';
import '../services/calendar_service.dart';
import '../services/goal_service.dart';
import '../services/badge_sync_service.dart';
import '../services/user_profile_service.dart';
import 'level_up_dialog.dart';

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
            goalColor: activeGoal.color
          );
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
            color: primaryColor.withValues(alpha: 0.15),
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

  // Calcule la taille adaptative des carrés en fonction du nombre de jours
  double _calculateSquareSize(int totalDays) {
    // Pour les petites durées (≤ 7 jours), carrés plus grands
    if (totalDays <= 7) return 24.0;
    
    // Pour les durées moyennes (8-21 jours), taille normale
    if (totalDays <= 21) return 18.0;
    
    // Pour les durées moyennes-élevées (22-42 jours), un peu plus petit
    if (totalDays <= 42) return 14.0;
    
    // Pour les durées élevées (43-70 jours), carrés plus petits
    if (totalDays <= 70) return 12.0;
    
    // Pour les très longues durées (> 70 jours), carrés très petits
    return 10.0;
  }

  // Calcule l'espacement adaptatif en fonction de la taille des carrés
  double _calculateSquareMargin(double squareSize) {
    if (squareSize >= 20) return 3.0;
    if (squareSize >= 16) return 2.5;
    if (squareSize >= 12) return 2.0;
    return 1.5;
  }

  Widget _buildCalendarMatrix(CalendarShape shape, int progress, int maxDays) {
    final daysCompleted = progress;
    final squareSize = _calculateSquareSize(maxDays);
    final squareMargin = _calculateSquareMargin(squareSize);

    // Déterminer le nombre optimal de colonnes basé sur le nombre total de jours
    final columnsPerRow = _calculateOptimalColumns(maxDays);
    
    // Créer une liste de tous les jours visibles
    final allDays = List.generate(maxDays, (index) => index + 1);
    
    // Organiser les jours en lignes
    final rows = <List<int>>[];
    for (int i = 0; i < allDays.length; i += columnsPerRow) {
      final endIndex = (i + columnsPerRow).clamp(0, allDays.length);
      rows.add(allDays.sublist(i, endIndex));
    }

    return Column(
      children: [
        const SizedBox(height: 4),
        ...rows.map((row) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: squareMargin / 2),
            child: Row(
              children: row.map((dayNumber) {
                final isCompleted = dayNumber <= daysCompleted;
                
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: squareSize,
                    margin: EdgeInsets.symmetric(horizontal: squareMargin),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? shape.color
                          : shape.color.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(squareSize * 0.15),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ],
    );
  }

  // Calcule le nombre optimal de colonnes par ligne selon le nombre total de jours
  int _calculateOptimalColumns(int totalDays) {
    // Pour les très petits nombres, une seule ligne
    if (totalDays <= 7) return totalDays;
    
    // Pour les durées moyennes, essayer de faire des lignes équilibrées
    if (totalDays <= 14) return 7;
    if (totalDays <= 21) return 7;
    if (totalDays <= 28) return 7;
    if (totalDays <= 42) return 7;
    
    // Pour les longues durées, plus de colonnes pour optimiser l'espace
    if (totalDays <= 70) return 10;
    if (totalDays <= 100) return 12;
    
    // Pour les très longues durées
    return 14;
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
                final levelUpResult = await profileService.addExperience(10); // XP pour session quotidienne
                
                // Afficher animation XP
                if (context.mounted) {
                  // Pour l'instant, on ne fait qu'un print, on ajoutera l'animation plus tard
                  print('Gained 10 XP!');
                }
                
                // Si level up, afficher popup
                if (levelUpResult != null && levelUpResult.hasLeveledUp && context.mounted) {
                  final badgeAsset = 'assets/badges/BADGE${levelUpResult.newLevel}.png';
                  final badgeName = profileService.userProfile?.levelName ?? 'Niveau ${levelUpResult.newLevel}';
                  final badgeDescription = 'Félicitations ! Vous avez atteint le niveau ${levelUpResult.newLevel} !';
                  
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => LevelUpDialog(
                      levelUpResult: levelUpResult,
                      badgeAssetPath: badgeAsset,
                      badgeName: badgeName,
                      badgeDescription: badgeDescription,
                    ),
                  );
                }
                
                goalService.updateProgress(goal.id, profileService);
                BadgeSyncService.checkAndUnlockBadges(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Session marquée comme complétée ! +10 XP',
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
          shadowColor: primaryColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildNoActiveGoal(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color.fromARGB(138, 255, 255, 255),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                136,
                239,
                128,
              ).withValues(alpha: 0.1),
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
