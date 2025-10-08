import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter/services.dart';
import '../services/goal_service.dart';

enum WidgetSize { small, large }

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
    final IconData iconData = goal?.icon ?? Icons.fitness_center;
    await HomeWidget.saveWidgetData<String>('widget_title', title);
    await HomeWidget.saveWidgetData<String>(
      'widget_icon',
      iconData.codePoint.toString(),
    );

    // Générer les heatmaps pour les deux tailles de widgets
    await _generateHeatmapForWidget(goalService, WidgetSize.small);
    await _generateHeatmapForWidget(goalService, WidgetSize.large);

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

  static Future<void> _generateHeatmapForWidget(
    GoalService goalService,
    WidgetSize widgetSize,
  ) async {
    final heatmapOnly = _HeatmapRender(
      goalService: goalService,
      widgetSize: widgetSize,
    );

    final (width, height) = _getWidgetDimensions(widgetSize);
    final keySuffix = widgetSize == WidgetSize.small ? '' : '_large';

    await HomeWidget.renderFlutterWidget(
      Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: goalService.activeGoal?.color.withValues(alpha: 0.25),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(
            goalService.activeGoal?.icon ?? Icons.fitness_center,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      key: 'icon_image$keySuffix',
      logicalSize: Size(30, 30),
    );

    await HomeWidget.renderFlutterWidget(
      Container(
        alignment: Alignment.center,
        child: SizedBox(width: width, height: height, child: heatmapOnly),
      ),
      key: 'heatmap_image$keySuffix',
      logicalSize: Size(width, height),
    );
  }

  // Dimensions des widgets selon leur taille
  static (double, double) _getWidgetDimensions(WidgetSize widgetSize) {
    switch (widgetSize) {
      case WidgetSize.small:
        return (300, 200);
      case WidgetSize.large:
        return (400.0, 220);
    }
  }

  // Calcul du nombre de jours à afficher selon la taille du widget
  static int _getMaxDaysForWidget(WidgetSize widgetSize) {
    switch (widgetSize) {
      case WidgetSize.small:
        // Widget carré : afficher 30 jours (5 semaines)
        return 60;
      case WidgetSize.large:
        // Widget rectangulaire : afficher 60 jours (8-9 semaines)
        return 90;
    }
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
  final WidgetSize widgetSize;

  const _HeatmapRender({required this.goalService, required this.widgetSize});

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
        widgetSize: widgetSize,
      ),
    );
  }
}

class _CompactHeatMap extends StatelessWidget {
  final dynamic activeGoal;
  final Color goalColor;
  final WidgetSize widgetSize;

  const _CompactHeatMap({
    required this.activeGoal,
    required this.goalColor,
    required this.widgetSize,
  });

  @override
  Widget build(BuildContext context) {
    // Créer les datasets pour HeatMap
    final Map<DateTime, int> datasets = {};
    for (final session in activeGoal.completedSessions) {
      final day = DateTime(session.year, session.month, session.day);
      datasets[day] = 7;
    }

    final colorsets = <int, Color>{
      1: goalColor.withValues(alpha: 0.25),
      2: goalColor.withValues(alpha: 0.35),
      3: goalColor.withValues(alpha: 0.45),
      4: goalColor.withValues(alpha: 0.60),
      5: goalColor.withValues(alpha: 0.70),
      6: goalColor.withValues(alpha: 0.85),
      7: goalColor.withValues(alpha: 1),
    };

    // Calculer le début du mois actuel
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    // Calculer le nombre de jours selon la taille du widget
    final maxDays = HomeWidgetService._getMaxDaysForWidget(widgetSize);
    final endDate = startOfMonth.add(Duration(days: maxDays));

    // Ajuster la taille des éléments selon le widget
    final (cellSize, fontSize, margin) = _getHeatmapDimensions(widgetSize);

    return ClipRect(
      child: HeatMap(
        startDate: startOfMonth,
        endDate: endDate,
        datasets: datasets,
        fontSize: fontSize,
        textColor: Colors.white,
        borderRadius: 5,
        colorsets: colorsets,
        defaultColor: goalColor.withValues(alpha: 0.25),
        size: cellSize,
        colorMode: ColorMode.color,
        showColorTip: false,
        margin: EdgeInsets.all(margin),
      ),
    );
  }

  // Dimensions des éléments du heatmap selon la taille du widget
  (double, double, double) _getHeatmapDimensions(WidgetSize widgetSize) {
    switch (widgetSize) {
      case WidgetSize.small:
        // Widget carré : éléments plus petits
        return (20.0, 16.0, 2.5);
      case WidgetSize.large:
        // Widget rectangulaire : éléments plus grands
        return (25.0, 20.0, 3.0);
    }
  }
}
