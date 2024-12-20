// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';

// Project imports:
import 'package:bites/core/constants/app_typography.dart';
import 'package:bites/core/models/weight_log_model.dart';
import 'package:bites/core/utils/measurement_utils.dart';
import 'package:bites/core/widgets/cards.dart';

class WeightProgressCard extends StatelessWidget {
  final List<WeightLog> weightLogs;
  final double? latestWeight;
  final bool isMetric;

  const WeightProgressCard({
    super.key,
    required this.weightLogs,
    this.latestWeight,
    required this.isMetric,
  });

  List<FlSpot> _getSpots() {
    final logsToShow = weightLogs.length > 10
        ? weightLogs.sublist(weightLogs.length - 10)
        : weightLogs;

    // Convert weight to appropriate unit
    final convertedWeightLogs = logsToShow.map((log) {
      return WeightLog(
        date: log.date,
        weight: MeasurementHelper.convertWeight(log.weight, isMetric),
      );
    }).toList();

    // Reverse the logs so newest is on the right
    final reversedLogs = convertedWeightLogs.reversed.toList();

    return List.generate(reversedLogs.length, (index) {
      final log = reversedLogs[index];
      return FlSpot(
        index.toDouble(),
        log.weight,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (weightLogs.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = _getSpots();
    final minX = 0.0;
    final maxX = (spots.length - 1).toDouble();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BaseCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weight Progress',
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (latestWeight != null)
                  Text(
                    MeasurementHelper.formatWeight(
                      latestWeight!,
                      isMetric,
                    ),
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  gridData: FlGridData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1, // Show every point
                        getTitlesWidget: (value, meta) {
                          final date =
                              weightLogs[weightLogs.length - 1 - value.toInt()]
                                  .date;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${date.day}/${date.month}',
                              style: AppTypography.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: AppTypography.bodySmall,
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
