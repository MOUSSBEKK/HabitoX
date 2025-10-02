import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter/services.dart';
import '../services/goal_service.dart';

class HomeWidgetService {
  static const String androidProvider = 'ActiveGoalHeatmapWidgetReceiver';
  static const String appGroupId = 'group.com.example.habitox';
  static const String iOSWidgetName = 'ActiveGoalHeatmapWidget';
  static const String data_key = 'widget_data';

  static const MethodChannel _channel = MethodChannel(
    'com.example.habitox/widget',
  );

  // Initialise l'App Group ID pour iOS
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
      debugPrint('✅ App Group ID configuré pour iOS: $appGroupId');
    } catch (e) {
      debugPrint('❌ Erreur configuration App Group ID: $e');
    }
  }

  static Future<void> updateActiveGoalHeatmap(
    BuildContext context,
    GoalService goalService,
  ) async {
    final goal = goalService.activeGoal;

    final String title = goal != null ? goal.title : 'HabitoX';
    final String iconData =
        goal?.icon.codePoint.toString() ??
        'fitness_center'; // Code point de l'icône

    await HomeWidget.saveWidgetData<String>('widget_title', title);
    await HomeWidget.saveWidgetData<String>('widget_icon', iconData);

    final heatmapOnly = _HeatmapRender(goalService: goalService);

    // Calculer la taille du widget en fonction de la durée de l'objectif
    final targetDays = goal?.targetDays ?? 30;
    final (widgetWidth, widgetHeight, logicalWidth, logicalHeight) =
        _calculateWidgetSize(targetDays);

    await HomeWidget.renderFlutterWidget(
      Container(
        color: const Color(0xFF1F222A),
        alignment: Alignment.center,
        child: SizedBox(width: 400, height: 350, child: heatmapOnly),
      ),
      key: 'heatmap_image',
      logicalSize: Size(400, 400),
    );

    try {
      // Mise à jour pour Android (Glance)
      final String result = await _channel.invokeMethod('updateWidget');
      debugPrint('✅ Widget Android mis à jour avec succès: $result');
    } catch (e) {
      debugPrint('❌ Mise à jour widget Android échouée: $e');
    }

    try {
      // Mise à jour pour iOS
      await HomeWidget.updateWidget(
        androidName: androidProvider,
        iOSName: iOSWidgetName,
      );
      debugPrint('✅ Widget iOS mis à jour avec succès');
    } catch (e) {
      debugPrint('❌ Mise à jour widget iOS échouée: $e');
    }
  }

  // Taille fixe du widget (60 jours maximum affichés)
  static (double, double, double, double) _calculateWidgetSize(int targetDays) {
    // Taille fixe car nous affichons toujours 60 jours maximum
    const double widgetWidth = 420;
    const double widgetHeight = 200;
    const double logicalWidth = 440;
    const double logicalHeight = 220;

    return (widgetWidth, widgetHeight, logicalWidth, logicalHeight);
  }

  // Méthode pour forcer la mise à jour du widget (debug)
  static Future<void> forceUpdateWidget() async {
    try {
      await HomeWidget.updateWidget();
      debugPrint('🔄 Mise à jour forcée du widget Glance');
    } catch (e) {
      debugPrint('❌ Échec mise à jour forcée Glance: $e');
    }
  }
}

class _HeatmapRender extends StatelessWidget {
  final GoalService goalService;

  const _HeatmapRender({required this.goalService});

  @override
  Widget build(BuildContext context) {
    final activeGoal = goalService.activeGoal;
    if (activeGoal == null) {
      return const SizedBox.shrink();
    }

    return Container(
      color: const Color(0xFF1F222A),
      width: double.infinity,
      height: double.infinity,
      child: _CompactHeatMap(
        activeGoal: activeGoal,
        goalColor: activeGoal.color,
      ),
    );
  }
}

class _CompactHeatMap extends StatelessWidget {
  final dynamic activeGoal;
  final Color goalColor;

  const _CompactHeatMap({required this.activeGoal, required this.goalColor});

  @override
  Widget build(BuildContext context) {
    // Créer les datasets pour HeatMap
    final Map<DateTime, int> datasets = {};
    for (final session in activeGoal.completedSessions) {
      final day = DateTime(session.year, session.month, session.day);
      datasets[day] = 7;
    }
    debugPrint('datasets: $datasets');

    final colorsets = <int, Color>{
      1: goalColor.withValues(alpha: 0.25),
      2: goalColor.withValues(alpha: 0.35),
      3: goalColor.withValues(alpha: 0.45),
      4: goalColor.withValues(alpha: 0.60),
      5: goalColor.withValues(alpha: 0.70),
      6: goalColor.withValues(alpha: 0.85),
      7: goalColor.withValues(alpha: 1),
    };

    // Calculer le début de la semaine actuelle (lundi)
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Limiter à 60 jours maximum pour garder le widget compact
    final maxDays = 60;
    final endDate = startOfWeek.add(Duration(days: maxDays));

    return ClipRect(
      child: HeatMap(
        startDate: startOfWeek,
        endDate: endDate,
        datasets: datasets,
        fontSize: 0,
        borderRadius: 5,
        colorsets: colorsets,
        defaultColor: goalColor.withValues(alpha: 0.25),
        size: 34,
        colorMode: ColorMode.color,
        showColorTip: false,
        margin: EdgeInsets.all(3.5),
      ),
    );
  }
}
