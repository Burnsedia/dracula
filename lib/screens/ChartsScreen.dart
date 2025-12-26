import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/bloodsugar.dart';
import '../services/database_helper.dart';
import '../services/settings_service.dart';
import './settings.dart';

class ChartsScreen extends StatefulWidget {
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  List<BloodSugarLog> records = [];
  bool _isLoading = true;
  BloodSugarUnit _displayUnit = BloodSugarUnit.mgdl;
  String _selectedPeriod = '7d'; // 7d, 30d, 90d

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
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

    setState(() {
      _displayUnit = unit;
      records = filteredRecords
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _isLoading = false;
    });
  }

  List<FlSpot> _generateSpots() {
    if (records.isEmpty) return [];

    final spots = <FlSpot>[];
    for (int i = 0; i < records.length; i++) {
      final value = SettingsService().convertToDisplayUnit(
        records[i].bloodSugar,
        _displayUnit,
      );
      spots.add(FlSpot(i.toDouble(), value));
    }
    return spots;
  }

  double _calculateAverage() {
    if (records.isEmpty) return 0;
    final sum = records.map((r) => r.bloodSugar).reduce((a, b) => a + b);
    return sum / records.length;
  }

  double _calculateMin() {
    if (records.isEmpty) return 0;
    return records.map((r) => r.bloodSugar).reduce((a, b) => a < b ? a : b);
  }

  double _calculateMax() {
    if (records.isEmpty) return 0;
    return records.map((r) => r.bloodSugar).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final unit = SettingsService().getUnitDisplayString(_displayUnit);
    final avg = SettingsService().convertToDisplayUnit(
      _calculateAverage(),
      _displayUnit,
    );
    final min = SettingsService().convertToDisplayUnit(
      _calculateMin(),
      _displayUnit,
    );
    final max = SettingsService().convertToDisplayUnit(
      _calculateMax(),
      _displayUnit,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Sugar Trends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            tooltip: 'Settings',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => _selectedPeriod = value);
              _loadData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7d', child: Text('Last 7 days')),
              const PopupMenuItem(value: '30d', child: Text('Last 30 days')),
              const PopupMenuItem(value: '90d', child: Text('Last 90 days')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
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
                  // Summary Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Average',
                          '${avg.toStringAsFixed(1)} $unit',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Range',
                          '${min.toStringAsFixed(1)} - ${max.toStringAsFixed(1)} $unit',
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
                                if (value.toInt() < records.length) {
                                  final date = records[value.toInt()].createdAt;
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
                  ...records.take(10).map((record) {
                    final value = SettingsService().convertToDisplayUnit(
                      record.bloodSugar,
                      _displayUnit,
                    );
                    return ListTile(
                      title: Text('${value.toStringAsFixed(1)} $unit'),
                      subtitle: Text(
                        '${record.createdAt.toString().split(' ')[0]} • ${record.isBeforeMeal ? "Before" : "After"} meal',
                      ),
                      dense: true,
                    );
                  }),
                ],
              ),
            ),
    );
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
}
