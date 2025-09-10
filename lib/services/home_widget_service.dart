import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
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
    final String title = 'HabitoX TEST';
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
            size: Size(400, 200),
            devicePixelRatio: 1.0,
          ),
          child: Container(
            color: const Color(0xFF1F222A),
            alignment: Alignment.center,
            child: SizedBox(width: 400, height: 200, child: heatmapOnly),
          ),
        ),
      ),
      key: 'heatmap_image',
      logicalSize: const Size(400, 200),
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
      // padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          // Calculer une taille de cellule plus grande pour le widget
          final cellSize = (width < height ? width : height) * 0.9 / 7;
          final cell = cellSize.clamp(8.0, 20.0);

          return _CompactHeatMapCalendar(
            activeGoal: activeGoal,
            shape: shape,
            squareSize: cell,
          );
        },
      ),
    );
  }
}

class _CompactHeatMapCalendar extends StatelessWidget {
  final dynamic activeGoal;
  final CalendarShape shape;
  final double? squareSize;

  const _CompactHeatMapCalendar({
    required this.activeGoal,
    required this.shape,
    this.squareSize,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 90));

    // Créer les datasets pour HeatMapCalendar
    final Map<DateTime, int> datasets = {};
    for (final session in activeGoal.completedSessions) {
      final day = DateTime(session.year, session.month, session.day);
      if (day.isBefore(start) || day.isAfter(now)) continue;
      datasets[day] = 7; // niveau d'intensité max
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

    final cellSize = squareSize ?? 8.0;
    final margin = cellSize >= 12 ? 2.0 : 1.2;

    return HeatMapCalendar(
      size: 25,
      margin: EdgeInsets.all(margin),
      fontSize: cellSize * 0.3,
      showColorTip: false,
      colorMode: ColorMode.color,
      defaultColor: const Color(0xFF1F222A),
      textColor: Colors.white70,
      weekTextColor: const Color(0xFFA7C6A5),
      datasets: datasets,
      colorsets: colorsets,
    );
  }
}
