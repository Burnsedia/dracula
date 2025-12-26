import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bloodsugar.dart';
import '../models/exercise.dart';
import '../services/database_helper.dart';
import '../services/settings_service.dart';

class AnalyticsTabsScreen extends StatefulWidget {
  const AnalyticsTabsScreen({super.key});

  @override
  _AnalyticsTabsScreenState createState() => _AnalyticsTabsScreenState();
}

class _AnalyticsTabsScreenState extends State<AnalyticsTabsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Trends tab data
  List<BloodSugarLog> _bloodSugarRecords = [];
  bool _isTrendsLoading = true;
  BloodSugarUnit _displayUnit = BloodSugarUnit.mgdl;
  String _selectedPeriod = '7d';

  // Analytics tab data
  List<ExerciseLog> _exerciseRecords = [];
  bool _isAnalyticsLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTrendsData();
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrendsData() async {
    if (mounted) setState(() => _isTrendsLoading = true);
    final unit = await SettingsService().getBloodSugarUnit();
    final allRecords = await DatabaseHelper.instance.readAll();

    // Filter by selected period
    final now = DateTime.now();
    final cutoff = switch (_selectedPeriod) {
      '7d' => now.subtract(const Duration(days: 7)),
      '30d' => now.subtract(const Duration(days: 30)),
      '90d' => now.subtract(const Duration(days: 90)),
      _ => now.subtract(const Duration(days: 7)),
    };

    final filteredRecords = allRecords
        .where((r) => r.createdAt.isAfter(cutoff))
        .toList();

    if (mounted) {
      setState(() {
        _displayUnit = unit;
        _bloodSugarRecords = filteredRecords
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _isTrendsLoading = false;
      });
    }
  }

  Future<void> _loadAnalyticsData() async {
    if (mounted) setState(() => _isAnalyticsLoading = true);
    final unit = await SettingsService().getBloodSugarUnit();
    final bloodSugar = await DatabaseHelper.instance.readAll();
    final exercises = await DatabaseHelper.instance.readAllExercises();
    if (mounted) {
      setState(() {
        _displayUnit = unit;
        _bloodSugarRecords = bloodSugar; // For analytics correlations
        _exerciseRecords = exercises;
        _isAnalyticsLoading = false;
      });
    }
  }

  // Trends tab methods
  List<FlSpot> _generateSpots() {
    if (_bloodSugarRecords.isEmpty) return [];

    final spots = <FlSpot>[];
    for (int i = 0; i < _bloodSugarRecords.length; i++) {
      final value = SettingsService().convertToDisplayUnit(
        _bloodSugarRecords[i].bloodSugar,
        _displayUnit,
      );
      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

  double _calculateAverage() {
    if (_bloodSugarRecords.isEmpty) return 0;
    final sum = _bloodSugarRecords
        .map((r) => r.bloodSugar)
        .reduce((a, b) => a + b);
    return sum / _bloodSugarRecords.length;
  }

  double _calculateMin() {
    if (_bloodSugarRecords.isEmpty) return 0;
    return _bloodSugarRecords
        .map((r) => r.bloodSugar)
        .reduce((a, b) => a < b ? a : b);
  }

  double _calculateMax() {
    if (_bloodSugarRecords.isEmpty) return 0;
    return _bloodSugarRecords
        .map((r) => r.bloodSugar)
        .reduce((a, b) => a > b ? a : b);
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Analytics tab methods
  List<BloodSugarLog> _getRecentRecords(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _bloodSugarRecords
        .where((r) => r.createdAt.isAfter(cutoff))
        .toList();
  }

  Map<String, double> _calculateCorrelations() {
    final correlations = <String, double>{};

    // Simple correlation: exercise duration vs blood sugar change
    final exerciseBloodSugarPairs = <List<double>>[];

    for (final exercise in _exerciseRecords) {
      final exerciseDate = exercise.createdAt;
      // Find blood sugar readings within 2 hours of exercise
      final nearbyReadings = _bloodSugarRecords.where((bs) {
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
            numerator / sqrt(denominator.abs());
      }
    }

    return correlations;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Trends'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Trends Tab
          _isTrendsLoading
              ? const Center(child: CircularProgressIndicator())
              : _bloodSugarRecords.isEmpty
              ? const Center(
                  child: Text(
                    'No data available for the selected period.\nAdd some readings to see trends.',
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Period selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              setState(() => _selectedPeriod = value);
                              _loadTrendsData();
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: '7d',
                                child: Text('Last 7 days'),
                              ),
                              const PopupMenuItem(
                                value: '30d',
                                child: Text('Last 30 days'),
                              ),
                              const PopupMenuItem(
                                value: '90d',
                                child: Text('Last 90 days'),
                              ),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Period: $_selectedPeriod'),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Summary Stats
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Average',
                              _calculateAverage() > 0
                                  ? SettingsService()
                                            .convertToDisplayUnit(
                                              _calculateAverage(),
                                              _displayUnit,
                                            )
                                            .toStringAsFixed(1) +
                                        ' ${SettingsService().getUnitDisplayString(_displayUnit)}'
                                  : 'N/A',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Range',
                              '${SettingsService().convertToDisplayUnit(_calculateMin(), _displayUnit).toStringAsFixed(1)} - ${SettingsService().convertToDisplayUnit(_calculateMax(), _displayUnit).toStringAsFixed(1)} ${SettingsService().getUnitDisplayString(_displayUnit)}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Chart
                      Text(
                        'Blood Sugar Trend (${_selectedPeriod})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) => Text(
                                    value.toStringAsFixed(0),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value.toInt() <
                                        _bloodSugarRecords.length) {
                                      final date =
                                          _bloodSugarRecords[value.toInt()]
                                              .createdAt;
                                      return Text(
                                        '${date.month}/${date.day}',
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _generateSpots(),
                                isCurved: true,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 3,
                                belowBarData: BarAreaData(show: false),
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Data points
                      Text(
                        'Recent Readings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ..._bloodSugarRecords.take(10).map((record) {
                        final value = SettingsService().convertToDisplayUnit(
                          record.bloodSugar,
                          _displayUnit,
                        );
                        return ListTile(
                          title: Text(
                            '${value.toStringAsFixed(1)} ${SettingsService().getUnitDisplayString(_displayUnit)}',
                          ),
                          subtitle: Text(
                            '${record.createdAt.toString().split(' ')[0]} • ${record.isBeforeMeal ? "Before" : "After"} meal',
                          ),
                          dense: true,
                        );
                      }),
                    ],
                  ),
                ),

          // Insights Tab
          _isAnalyticsLoading
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
                              _getRecentRecords(30).isNotEmpty
                                  ? SettingsService()
                                        .convertToDisplayUnit(
                                          _getRecentRecords(30)
                                                  .map((r) => r.bloodSugar)
                                                  .reduce((a, b) => a + b) /
                                              _getRecentRecords(30).length,
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
                              _exerciseRecords.length.toString(),
                              'sessions',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Correlations
                      if (_calculateCorrelations().isNotEmpty) ...[
                        Text(
                          'Correlations',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ..._calculateCorrelations().entries.map(
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
                                    toY: _getRecentRecords(30)
                                        .where((r) => r.isBeforeMeal)
                                        .length
                                        .toDouble(),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: _getRecentRecords(30)
                                        .where((r) => !r.isBeforeMeal)
                                        .length
                                        .toDouble(),
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
                      if (_exerciseRecords.isNotEmpty) ...[
                        SizedBox(
                          height: 200,
                          child: ScatterChart(
                            ScatterChartData(
                              scatterSpots: _exerciseRecords.map((exercise) {
                                // Find blood sugar change around exercise
                                final exerciseTime = exercise.createdAt;
                                final readings = _bloodSugarRecords.where((bs) {
                                  final diff = bs.createdAt
                                      .difference(exerciseTime)
                                      .inMinutes
                                      .abs();
                                  return diff <= 120;
                                }).toList();

                                double change = 0;
                                if (readings.length >= 2) {
                                  readings.sort(
                                    (a, b) =>
                                        a.createdAt.compareTo(b.createdAt),
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
                                    color: change < 0
                                        ? Colors.green
                                        : Colors.red,
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
        ],
      ),
    );
  }
}
