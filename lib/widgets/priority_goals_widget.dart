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

class PriorityGoalsWidget extends StatefulWidget {
  final Function(int)? onSwitchTab;

  const PriorityGoalsWidget({super.key, this.onSwitchTab});

  @override
  State<PriorityGoalsWidget> createState() => _PriorityGoalsWidgetState();
}

class _PriorityGoalsWidgetState extends State<PriorityGoalsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  String? _completedGoalId;
  bool _isAnimating = false;
  String? _sessionCompletedGoalId; // Pour les sessions normales

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(
        milliseconds: 1000,
      ), // Légèrement plus rapide pour un meilleur feeling
      vsync: this,
    );

    // Phase 1: Slide out + fade out (0-0.4s)
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.33, curve: Curves.easeInOut),
      ),
    );

    // Phase 2: Cards move up (0.4-0.8s)
    // Phase 3: New card scale up + fade in (0.8-1.2s)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.66, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation(String goalId, {bool isGoalCompleted = false}) {
    setState(() {
      if (isGoalCompleted) {
        _completedGoalId = goalId;
      } else {
        _sessionCompletedGoalId = goalId;
      }
      _isAnimating = true;
    });

    _animationController.forward().then((_) {
      setState(() {
        _isAnimating = false;
        _completedGoalId = null;
        _sessionCompletedGoalId = null;
      });
      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GoalService, CalendarService>(
      builder: (context, goalService, calendarService, child) {
        final allActiveGoals = goalService.activeGoals;

        // Filtrer les objectifs pour ne montrer que ceux qui n'ont pas été marqués aujourd'hui
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final activeGoals = allActiveGoals.where((goal) {
          final alreadyCompletedToday = goal.completedSessions.any(
            (session) =>
                DateTime(session.year, session.month, session.day) == today,
          );
          return !alreadyCompletedToday; // Ne montrer que les objectifs non marqués aujourd'hui
        }).toList();

        if (activeGoals.isEmpty) {
          // Si tous les objectifs ont été marqués aujourd'hui, afficher un message spécial
          if (allActiveGoals.isNotEmpty) {
            return _buildAllSessionsCompletedToday(context);
          }
          return _buildNoActiveGoals(context);
        }

        // Vérifier si tous les objectifs sont terminés
        if (goalService.allActiveGoalsCompleted) {
          return _buildAllGoalsCompleted(context);
        }

        return SizedBox(
          height: 450.0, // Hauteur fixe pour toutes les cartes
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Afficher les objectifs superposés dans l'ordre inverse pour que la priorité 1 soit au-dessus
              ...activeGoals
                  .asMap()
                  .entries
                  .map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    return _buildStackedGoalCard(
                      context,
                      goal,
                      index,
                      goalService,
                      calendarService,
                    );
                  })
                  .toList()
                  .reversed
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStackedGoalCard(
    BuildContext context,
    dynamic goal,
    int stackIndex,
    GoalService goalService,
    CalendarService calendarService,
  ) {
    // SYSTÈME DE PRIORITÉS :
    // - Priorité 1 (Haute) = Rouge, position visuelle 0 (tout devant)
    // - Priorité 2 (Moyenne) = Orange, position visuelle 1 (au milieu)
    // - Priorité 3 (Basse) = Bleu, position visuelle 2 (à l'arrière)
    //
    // Conversion de la priorité en position visuelle
    final visualIndex = goal.priority - 1; // Priorité 1->0, 2->1, 3->2

    // Positionnement selon la priorité (plus la priorité est haute, plus c'est devant)
    final verticalOffset =
        visualIndex * 8.0; // Carte Moyenne: 8px, Carte Basse: 16px
    final horizontalOffset =
        visualIndex * 8.0; // Décalage horizontal correspondant

    final isCompleted = _completedGoalId == goal.id;
    final isSessionCompleted = _sessionCompletedGoalId == goal.id;
    final isFirstCard =
        visualIndex == 0; // La carte de priorité 1 (Haute) est la première

    return Positioned(
      top: verticalOffset,
      left: horizontalOffset,
      right: horizontalOffset,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          // Phase 1: Slide out + fade out pour la carte complétée ou session marquée
          if ((isCompleted || isSessionCompleted) && isFirstCard) {
            return Transform.translate(
              offset: Offset(
                _slideAnimation.value * 300,
                0,
              ), // Slide vers la droite
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: _buildGoalCard(
                  context,
                  goal,
                  goalService,
                  calendarService,
                ),
              ),
            );
          }

          // Phase 2: Animation des cartes arrière-plan (les cartes de priorité inférieure remontent)
          if (_isAnimating && !isFirstCard) {
            final moveUpAnimation =
                Tween<double>(
                  begin: 0.0,
                  end:
                      -8.0, // Remonte de 8px pour prendre la position de la carte disparue
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.33, 0.66, curve: Curves.easeInOut),
                  ),
                );

            return Transform.translate(
              offset: Offset(0, moveUpAnimation.value),
              child: _buildGoalCard(
                context,
                goal,
                goalService,
                calendarService,
              ),
            );
          }

          // Phase 3: Nouvelle carte active (priorité la plus haute restante) apparaît avec animation
          if (_isAnimating &&
              isFirstCard &&
              !isCompleted &&
              !isSessionCompleted) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildGoalCard(
                context,
                goal,
                goalService,
                calendarService,
              ),
            );
          }

          // État normal
          return _buildGoalCard(context, goal, goalService, calendarService);
        },
      ),
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    dynamic goal,
    GoalService goalService,
    CalendarService calendarService,
  ) {
    // S'assurer que la forme du calendrier existe pour cet objectif
    final currentShape = calendarService.currentShape;
    if (currentShape == null ||
        currentShape.totalDays != goal.targetDays ||
        currentShape.color != goal.color) {
      calendarService.ensureShapeForTargetDays(
        goal.targetDays,
        goalColor: goal.color,
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            goal.icon,
            goal.title,
            goal.description,
            goal.priority,
            calendarService.currentShape!,
            context,
          ),
          _buildMarkSessionButton(context, goalService, goal),
          const SizedBox(height: 24),
          // if (calendarService.currentShape != null)
          _buildCalendarSection(
            calendarService.currentShape!,
            goal,
            calendarService,
            context,
          ),
          // else
          // _buildEmptyCalendarCard(context),
          const SizedBox(height: 20),
          if (calendarService.currentShape != null)
            _buildProgressInfo(calendarService.currentShape!, goal, context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(
    IconData icon,
    String title,
    String description,
    int priority,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(priority).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getPriorityColor(
                          priority,
                        ).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      _getPriorityLabel(priority),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getPriorityColor(priority),
                      ),
                    ),
                  ),
                ],
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

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Haute';
      case 2:
        return 'Moyenne';
      case 3:
        return 'Basse';
      default:
        return 'Priorité $priority';
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red; // Haute priorité = Rouge
      case 2:
        return Colors.orange; // Moyenne priorité = Orange
      case 3:
        return Colors.blue; // Basse priorité = Bleu
      default:
        return Colors.grey;
    }
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
      size: 35,
      fontSize: 14,
      monthFontSize: 16,
      weekFontSize: 14,
      showColorTip: false,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).textTheme.bodyMedium?.color,
      // weekTextColor: Color(0xFFA7C6A5),
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
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        onPressed: () async {
          final profileService = context.read<UserProfileService>();
          final int experience = 2;
          // Utiliser le nouveau système XP
          await profileService.addExperience(experience);

          final updateResult = await goalService.updateProgress(
            goal.id,
            profileService,
          );

          // Démarrer l'animation selon le résultat
          if (updateResult != null) {
            if (updateResult['goalCompleted'] == true) {
              // Objectif terminé complètement - animation de disparition définitive
              _startAnimation(goal.id, isGoalCompleted: true);

              final xpGained = updateResult['xpGained'] as int? ?? 0;
              final levelUpResult = updateResult['levelUpResult'];

              toastification.show(
                context: context,
                title: const Text('🎉 Objectif terminé !'),
                description: Text('Félicitations ! +$xpGained XP'),
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
                    badgeDescription: 'Vous avez atteint un nouveau niveau !',
                  ),
                );
              }
            } else {
              // Session normale - animation temporaire
              _startAnimation(goal.id, isGoalCompleted: false);

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
          "Marquer Session",
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

  Widget _buildNoActiveGoals(BuildContext context) {
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
            'Aucun objectif actif',
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
            'Créez jusqu\'à 3 objectifs pour commencer votre parcours !',
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

  Widget _buildAllSessionsCompletedToday(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône de succès quotidien
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFA7C6A5).withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.calendarCheck,
                size: 50,
                color: Color(0xFFA7C6A5),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Titre de succès
          Text(
            '✅ Journée accomplie !',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA7C6A5),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Message explicatif
          Text(
            'Vous avez marqué toutes vos sessions d\'aujourd\'hui !\nVos objectifs réapparaîtront demain.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Message d'encouragement
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFA7C6A5).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFA7C6A5).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              '🌟 Excellent travail ! Reposez-vous et revenez demain pour continuer votre progression.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFA7C6A5),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllGoalsCompleted(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône de félicitations
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.trophy,
                size: 50,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Titre de félicitations
          Text(
            '🎉 Félicitations ! 🎉',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.green,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Message de félicitations
          Text(
            'Vous avez accompli tous vos objectifs !\nContinuez sur cette lancée !',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Bouton pour créer de nouveaux objectifs
          ElevatedButton.icon(
            onPressed: () {
              if (widget.onSwitchTab != null) {
                widget.onSwitchTab!(1); // Aller à l'onglet objectifs
              }
            },
            icon: FaIcon(FontAwesomeIcons.plus, size: 16),
            label: Text('Créer de nouveaux objectifs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA7C6A5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
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
