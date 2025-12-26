import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bloodsugar.dart';
import '../models/exercise.dart';
import '../services/database_helper.dart';
import '../services/settings_service.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<BloodSugarLog> bloodSugarRecords = [];
  List<ExerciseLog> exerciseRecords = [];
  bool _isLoading = true;
  BloodSugarUnit _displayUnit = BloodSugarUnit.mgdl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _isLoading = true);
    final unit = await SettingsService().getBloodSugarUnit();
    final bloodSugar = await DatabaseHelper.instance.readAll();
    final exercises = await DatabaseHelper.instance.readAllExercises();
    if (mounted)
      setState(() {
        _displayUnit = unit;
        bloodSugarRecords = bloodSugar;
        exerciseRecords = exercises;
        _isLoading = false;
      });
  }

  List<BloodSugarLog> _getRecentRecords(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return bloodSugarRecords.where((r) => r.createdAt.isAfter(cutoff)).toList();
  }

  Map<String, double> _calculateCorrelations() {
    final correlations = <String, double>{};

    // Simple correlation: exercise duration vs blood sugar change
    final exerciseBloodSugarPairs = <List<double>>[];

    for (final exercise in exerciseRecords) {
      final exerciseDate = exercise.createdAt;
      // Find blood sugar readings within 2 hours of exercise
      final nearbyReadings = bloodSugarRecords.where((bs) {
        final diff = (bs.createdAt.difference(exerciseDate)).inMinutes.abs();
        return diff <= 120; // 2 hours
      }).toList();

      if (nearbyReadings.length >= 2) {
        nearbyReadings.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        final beforeReading = nearbyReadings.firstWhere(
          (bs) => bs.createdAt.isBefore(exerciseDate),
          orElse: () => nearbyReadings.first,
        );
        final afterReading = nearbyReadings.firstWhere(
          (bs) => bs.createdAt.isAfter(exerciseDate),
          orElse: () => nearbyReadings.last,
        );

        final change = afterReading.bloodSugar - beforeReading.bloodSugar;
        exerciseBloodSugarPairs.add([
          exercise.durationMinutes.toDouble(),
          change,
        ]);
      }
    }

    if (exerciseBloodSugarPairs.isNotEmpty) {
      // Calculate simple correlation coefficient
      final n = exerciseBloodSugarPairs.length;
      final sumX = exerciseBloodSugarPairs
          .map((p) => p[0])
          .reduce((a, b) => a + b);
      final sumY = exerciseBloodSugarPairs
          .map((p) => p[1])
          .reduce((a, b) => a + b);
      final sumXY = exerciseBloodSugarPairs
          .map((p) => p[0] * p[1])
          .reduce((a, b) => a + b);
      final sumX2 = exerciseBloodSugarPairs
          .map((p) => p[0] * p[0])
          .reduce((a, b) => a + b);
      final sumY2 = exerciseBloodSugarPairs
          .map((p) => p[1] * p[1])
          .reduce((a, b) => a + b);

      final numerator = n * sumXY - sumX * sumY;
      final denominator = (n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY);

      if (denominator > 0) {
        correlations['Exercise Duration vs Blood Sugar Change'] =
            numerator / sqrt(denominator);
      }
    }

    return correlations;
  }

  @override
  Widget build(BuildContext context) {
    final correlations = _calculateCorrelations();
    final recentRecords = _getRecentRecords(30);

    return Scaffold(
      appBar: AppBar(title: const Text('Health Analytics')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Avg Blood Sugar (30d)',
                          recentRecords.isNotEmpty
                              ? SettingsService()
                                    .convertToDisplayUnit(
                                      recentRecords
                                              .map((r) => r.bloodSugar)
                                              .reduce((a, b) => a + b) /
                                          recentRecords.length,
                                      _displayUnit,
                                    )
                                    .toStringAsFixed(1)
                              : 'N/A',
                          'mg/dL',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildMetricCard(
                          'Total Exercises',
                          exerciseRecords.length.toString(),
                          'sessions',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Correlations
                  if (correlations.isNotEmpty) ...[
                    Text(
                      'Correlations',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...correlations.entries.map(
                      (entry) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(entry.key),
                          trailing: Text(
                            '${entry.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: entry.value > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Trend Analysis
                  Text(
                    'Blood Sugar Trends by Meal Timing',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: recentRecords
                                    .where((r) => r.isBeforeMeal)
                                    .length
                                    .toDouble(),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: recentRecords
                                    .where((r) => !r.isBeforeMeal)
                                    .length
                                    .toDouble(),
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return const Text('Before Meal');
                                  case 1:
                                    return const Text('After Meal');
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Exercise Impact Analysis
                  Text(
                    'Exercise Impact on Blood Sugar',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (exerciseRecords.isNotEmpty) ...[
                    SizedBox(
                      height: 200,
                      child: ScatterChart(
                        ScatterChartData(
                          scatterSpots: exerciseRecords.map((exercise) {
                            // Find blood sugar change around exercise
                            final exerciseTime = exercise.createdAt;
                            final readings = bloodSugarRecords.where((bs) {
                              final diff = bs.createdAt
                                  .difference(exerciseTime)
                                  .inMinutes
                                  .abs();
                              return diff <= 120;
                            }).toList();

                            double change = 0;
                            if (readings.length >= 2) {
                              readings.sort(
                                (a, b) => a.createdAt.compareTo(b.createdAt),
                              );
                              final before = readings.firstWhere(
                                (bs) => bs.createdAt.isBefore(exerciseTime),
                                orElse: () => readings.first,
                              );
                              final after = readings.firstWhere(
                                (bs) => bs.createdAt.isAfter(exerciseTime),
                                orElse: () => readings.last,
                              );
                              change = after.bloodSugar - before.bloodSugar;
                            }

                            return ScatterSpot(
                              exercise.durationMinutes.toDouble(),
                              change,
                              dotPainter: FlDotCirclePainter(
                                color: change < 0 ? Colors.green : Colors.red,
                              ),
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    Text(value.toStringAsFixed(0)),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    Text('${value.toInt()}min'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Duration vs Blood Sugar Change (negative = improvement)',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ] else ...[
                    const Text(
                      'Add exercise and blood sugar data to see correlations',
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(String title, String value, String unit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(unit, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
