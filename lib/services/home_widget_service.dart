import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import '../services/goal_service.dart';
import '../services/calendar_service.dart';
import '../models/calendar_shape.dart';

class HomeWidgetService {
  // IMPORTANT: fournir seulement le nom de classe (le plugin préfixe avec applicationId)
  static const String androidProvider = 'ActiveGoalHeatmapWidgetProvider';

  static Future<void> updateActiveGoalHeatmap(
    BuildContext context,
    GoalService goalService,
    CalendarService calendarService,
  ) async {
    final goal = goalService.activeGoal;

    // Préparer des titres
    final String title = 'HabitoX';
    final String subtitle = goal != null ? goal.title : 'No active goal';

    await HomeWidget.saveWidgetData<String>('widget_title', title);
    await HomeWidget.saveWidgetData<String>('widget_subtitle', subtitle);

    // Rendre un widget Flutter en image pour le heatmap
    // On utilise un widget spécifique qui ne dépend pas des Consumers, pour un rendu isolé
    final heatmapOnly = _HeatmapRender(
      calendarService: calendarService,
      goalService: goalService,
    );

    await HomeWidget.renderFlutterWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 160),
            devicePixelRatio: 1.0,
          ),
          child: Container(
            color: const Color(0xFF1F222A),
            alignment: Alignment.center,
            child: SizedBox(width: 320, height: 160, child: heatmapOnly),
          ),
        ),
      ),
      key: 'heatmap_image',
      logicalSize: const Size(320, 160),
    );

    try {
      await HomeWidget.updateWidget(name: androidProvider);
    } catch (e) {
      // Si aucun widget n'est ajouté, le plugin peut lever une erreur (ClassNotFoundException)
      // On ignore silencieusement pour ne pas perturber le flux de l'application
      debugPrint('HomeWidget update ignorée: $e');
    }
  }
}

class _HeatmapRender extends StatelessWidget {
  final GoalService goalService;
  final CalendarService calendarService;

  const _HeatmapRender({
    required this.goalService,
    required this.calendarService,
  });

  @override
  Widget build(BuildContext context) {
    final activeGoal = goalService.activeGoal;
    if (activeGoal == null) {
      return const SizedBox.shrink();
    }

    // Déterminer le shape à utiliser sans dépendre d'opérations async
    final currentShape = calendarService.currentShape;
    final shape =
        (currentShape != null &&
            currentShape.totalDays == activeGoal.targetDays)
        ? currentShape
        : CalendarShape.createForTargetDays(
            activeGoal.targetDays,
            goalColor: activeGoal.color,
          );

    // Afficher uniquement la grille de heatmap compacte avec LayoutBuilder
    return Container(
      color: const Color(0xFF1F222A),
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final shortest = width < height ? width : height;
          // Ajuster la taille des cases en fonction de la place disponible
          final totalDays = shape.totalDays;
          final cols = _CompactHeatmap.columnsFor(totalDays);
          final rows = (totalDays / cols).ceil();
          final hSpace = width - 16; // padding total 8 + 8
          final vSpace = height - 16;
          final cellWidth = (hSpace / cols).clamp(4.0, 16.0);
          final cellHeight = (vSpace / rows).clamp(4.0, 16.0);
          final cell = cellWidth < cellHeight ? cellWidth : cellHeight;

          return _CompactHeatmap(
            totalDays: totalDays,
            completedDays: activeGoal.totalDays,
            color: shape.color,
            squareSize: cell,
          );
        },
      ),
    );
  }
}

class _CompactHeatmap extends StatelessWidget {
  final int totalDays;
  final int completedDays;
  final Color color;
  final double? squareSize;

  const _CompactHeatmap({
    required this.totalDays,
    required this.completedDays,
    required this.color,
    this.squareSize,
  });

  static int columnsFor(int total) {
    if (total <= 7) return total;
    if (total <= 14) return 7;
    if (total <= 21) return 7;
    if (total <= 28) return 7;
    if (total <= 42) return 7;
    if (total <= 70) return 10;
    if (total <= 100) return 12;
    return 14;
  }

  @override
  Widget build(BuildContext context) {
    final cols = columnsFor(totalDays);
    final rows = (totalDays / cols).ceil();
    final squareSize = this.squareSize ?? 8.0;
    final margin = squareSize >= 12 ? 2.0 : 1.2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(rows, (r) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: margin / 2),
          child: Row(
            children: List.generate(cols, (c) {
              final index = r * cols + c;
              if (index >= totalDays) {
                return const SizedBox.shrink();
              }
              final filled = index + 1 <= completedDays;
              return Expanded(
                child: Container(
                  height: squareSize,
                  margin: EdgeInsets.symmetric(horizontal: margin),
                  decoration: BoxDecoration(
                    color: filled ? color : color.withAlpha(64),
                    borderRadius: BorderRadius.circular(squareSize * 0.15),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
