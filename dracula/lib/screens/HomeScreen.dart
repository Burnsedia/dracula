import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import '../services/database_helper.dart';
import '../services/settings_service.dart';
import '../componets/sidebar.dart';
import "./AddBloodSugar.dart";
import "./settings.dart";

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
          : bloodSugarRecords.isEmpty
              ? const Center(
                  child: Text(
                    'No blood sugar records yet.\nTap + to add your first entry.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
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
