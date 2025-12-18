import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../services/database_helper.dart";
import "../services/settings_service.dart";
import "../componets/sidebar.dart";
import "./AddBloodSugar.dart";
import "./settings.dart";
import "./ExerciseList.dart";
import "./ChartsScreen.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BloodSugarLog> bloodSugarRecords = [];
  bool _isLoading = true;
  BloodSugarUnit _displayUnit = BloodSugarUnit.mgdl;
  bool _showTimezone = true;

  @override
  void initState() {
    super.initState();
    _loadSettingsAndRecords();
  }

  Future<void> _loadSettingsAndRecords() async {
    setState(() => _isLoading = true);

    // Load settings
    final unit = await SettingsService().getBloodSugarUnit();
    final showTimezone = await SettingsService().getShowTimezone();

    // Load records
    final records = await DatabaseHelper.instance.readAll();

    setState(() {
      _displayUnit = unit;
      _showTimezone = showTimezone;
      bloodSugarRecords = records;
      _isLoading = false;
    });
  }

  Future<void> _loadRecords() async {
    final records = await DatabaseHelper.instance.readAll();
    setState(() => bloodSugarRecords = records);
  }

  void _showEditDeleteMenu(BuildContext context, BloodSugarLog record) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _editRecord(record);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                  _confirmDelete(record);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editRecord(BloodSugarLog record) async {
    final updatedRecord = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRecordScreen(record: record),
      ),
    );

    if (updatedRecord != null) {
      await _loadRecords(); // Refresh from database
    }
  }

  void _confirmDelete(BloodSugarLog record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Record'),
          content: const Text(
              'Are you sure you want to delete this blood sugar record?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _deleteRecord(record);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecord(BloodSugarLog record) async {
    if (record.id != null) {
      await DatabaseHelper.instance.delete(record.id!);
      await _loadRecords(); // Refresh from database

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record deleted successfully')),
        );
      }
    }
  }

  Widget _buildSummaryCards() {
    final today = DateTime.now();
    final todayRecords = bloodSugarRecords.where((record) {
      final recordDate = DateTime(
          record.createdAt.year, record.createdAt.month, record.createdAt.day);
      final todayDate = DateTime(today.year, today.month, today.day);
      return recordDate == todayDate;
    }).toList();

    final average = todayRecords.isNotEmpty
        ? todayRecords.map((r) => r.bloodSugar).reduce((a, b) => a + b) /
            todayRecords.length
        : 0.0;
    final latest = todayRecords.isNotEmpty
        ? todayRecords
            .reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b)
            .bloodSugar
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Today\'s Average',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      average > 0
                          ? SettingsService()
                              .convertToDisplayUnit(average, _displayUnit)
                              .toStringAsFixed(1)
                          : '--',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      SettingsService().getUnitDisplayString(_displayUnit),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Latest Reading',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      latest != null
                          ? SettingsService()
                              .convertToDisplayUnit(latest, _displayUnit)
                              .toStringAsFixed(1)
                          : '--',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      SettingsService().getUnitDisplayString(_displayUnit),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date = dateTime.toString().split(' ')[0]; // YYYY-MM-DD
    if (_showTimezone) {
      final timezone = dateTime.timeZoneName;
      return '$date ($timezone)';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Sugar Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChartsScreen()),
              );
            },
            tooltip: 'View Charts',
          ),
          IconButton(
            icon: const Icon(Icons.fitness_center),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExerciseListScreen()),
              );
            },
            tooltip: 'Exercise Tracker',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              // Reload settings and records when returning from settings
              await _loadSettingsAndRecords();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (bloodSugarRecords.isNotEmpty) _buildSummaryCards(),
                Expanded(
                  child: bloodSugarRecords.isEmpty
                      ? const Center(
                          child: Text(
                            'No blood sugar records yet.\nTap + to add your first entry.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: bloodSugarRecords.length,
                          itemBuilder: (context, index) {
                            final record = bloodSugarRecords[index];
                            final displayValue = SettingsService()
                                .convertToDisplayUnit(
                                    record.bloodSugar, _displayUnit);
                            final unitString = SettingsService()
                                .getUnitDisplayString(_displayUnit);

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  'Blood Sugar: ${displayValue.toStringAsFixed(1)} $unitString',
                                ),
                                subtitle: Text(
                                  '${record.isBeforeMeal ? "Before" : "After"} meal • ${_formatDateTime(record.createdAt)}',
                                ),
                                onLongPress: () =>
                                    _showEditDeleteMenu(context, record),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecordScreen()),
          );
          if (newRecord != null) {
            await _loadRecords(); // Refresh from database
          }
        },
        tooltip: 'Add Blood Sugar Record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
