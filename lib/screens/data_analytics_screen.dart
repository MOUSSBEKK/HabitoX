import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../services/goal_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../l10n/app_localizations.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class DataAnalyticsScreen extends StatefulWidget {
  const DataAnalyticsScreen({super.key});

  @override
  State<DataAnalyticsScreen> createState() => _DataAnalyticsScreenState();
}

class _DataAnalyticsScreenState extends State<DataAnalyticsScreen> {
  int _selectedTimeRange = 0; // 0: Week, 1: Month, 2: Lifetime

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Consumer<GoalService>(
        builder: (context, goalService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Filtres de période
                // _buildTimeRangeFilters(),
                // const SizedBox(height: 24),

                // Cartes de statistiques globales
                _buildGlobalStatsCards(goalService),
                const SizedBox(height: 24),

                // Graphique des objectifs terminés par jour
                _buildDailyCompletionsChart(goalService),
                const SizedBox(height: 24),

                // Graphique marquages vs oublis
                _buildMarkingsVsMissesChart(goalService),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _buildTimeRangeFilters() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       _buildTimeRangeChip('Week', 0),
  //       _buildTimeRangeChip('Month', 1),
  //       _buildTimeRangeChip('Lifetime', 2),
  //     ],
  //   );
  // }

  // Widget _buildTimeRangeChip(String label, int index) {
  //   final isSelected = _selectedTimeRange == index;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         _selectedTimeRange = index;
  //       });
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? Theme.of(context).colorScheme.secondary
  //             : const Color(0xFF2A2A2A),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Text(
  //         label,
  //         style: TextStyle(
  //           color: isSelected ? Colors.white : Colors.grey[400],
  //           fontWeight: FontWeight.w600,
  //           fontSize: 16,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildGlobalStatsCards(GoalService goalService) {
    return Row(
      children: [
        Expanded(
          child: _buildGlobalStatCard(
            AppLocalizations.of(context)!.analytics_completions,
            goalService.totalCompletedGoals.toString(),
            FontAwesomeIcons.circleCheck,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildGlobalStatCard(
            AppLocalizations.of(context)!.analytics_archives,
            _getArchivedGoalsCount(goalService).toString(),
            FontAwesomeIcons.archive,
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withAlpha(70),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 16,
            ),
          ),

          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _getArchivedGoalsCount(GoalService goalService) {
    return goalService.getArchivedGoalsCount();
  }

  Widget _buildDailyCompletionsChart(GoalService goalService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.analytics_completions_day,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(70),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  Icons.show_chart,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 10,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = goalService.getChartLabels(
                          _selectedTimeRange,
                        );
                        if (value.toInt() >= 0 &&
                            value.toInt() < labels.length) {
                          return Text(
                            labels[value.toInt()],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getDailyCompletionsData(goalService),
                    isCurved: true,
                    preventCurveOverShooting: true,
                    isStrokeCapRound: true,
                    color: Theme.of(context).colorScheme.secondary,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(30),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkingsVsMissesChart(GoalService goalService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.analytics_marking_omissions,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(70),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(
                  HugeIconsStroke.pieChart02,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _getMarkingsVsMissesPieData(goalService),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPieChartLegend(goalService),
        ],
      ),
    );
  }

  List<FlSpot> _getDailyCompletionsData(GoalService goalService) {
    return goalService.getDailyCompletionsData(_selectedTimeRange);
  }

  List<PieChartSectionData> _getMarkingsVsMissesPieData(
    GoalService goalService,
  ) {
    // Utiliser les données de la semaine courante (timeRange = 0)
    final data = goalService.getMarkingsVsMissesData(0);
    final markings = data['markings'] ?? 0;
    final misses = data['misses'] ?? 0;
    final total = markings + misses;

    if (total == 0) {
      // Si aucune donnée, afficher un cercle vide avec un message
      return [
        PieChartSectionData(
          color: Colors.grey[300]!,
          value: 100,
          title: AppLocalizations.of(context)!.analytics_nodata,
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ];
    }

    // Calculer les pourcentages
    final markingsPercent = (markings / total * 100);
    final missesPercent = (misses / total * 100);

    return [
      PieChartSectionData(
        color: Theme.of(
          context,
        ).colorScheme.secondary, // Vert pour les marquages
        value: markingsPercent,
        title: '${markingsPercent.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(
          255,
          234,
          85,
          75,
        ), // Couleur secondaire pour les oublis
        value: missesPercent,
        title: '${missesPercent.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildPieChartLegend(GoalService goalService) {
    final data = goalService.getMarkingsVsMissesData(0);
    final markings = data['markings'] ?? 0;
    final misses = data['misses'] ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(
          AppLocalizations.of(context)!.analytics_marking,
          Theme.of(context).colorScheme.secondary,
          markings,
        ),
        _buildLegendItem(
          AppLocalizations.of(context)!.analytics_omissions,
          const Color.fromARGB(255, 234, 85, 75),
          misses,
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
