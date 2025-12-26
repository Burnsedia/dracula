import 'package:flutter/material.dart';
import "../models/exercise.dart";
import "../services/database_helper.dart";
import "../services/settings_service.dart";
import "./AddExercise.dart";
import "./settings.dart";

class ExerciseListScreen extends StatefulWidget {
  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  List<ExerciseLog> exerciseRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.readAllExercises();
    setState(() {
      exerciseRecords = records;
      _isLoading = false;
    });
  }

  void _showEditDeleteMenu(BuildContext context, ExerciseLog record) {
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
                  Navigator.pop(context);
                  _editRecord(record);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(record);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editRecord(ExerciseLog record) async {
    final updatedRecord = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExerciseScreen(record: record),
      ),
    );

    if (updatedRecord != null) {
      await _loadRecords();
    }
  }

  void _confirmDelete(ExerciseLog record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Record'),
          content: const Text(
            'Are you sure you want to delete this exercise record?',
          ),
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
                Navigator.of(context).pop();
                await _deleteRecord(record);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRecord(ExerciseLog record) async {
    if (record.id != null) {
      await DatabaseHelper.instance.deleteExercise(record.id!);
      await _loadRecords();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record deleted successfully')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : exerciseRecords.isEmpty
          ? const Center(
              child: Text(
                'No exercise records yet.\nTap + to add your first entry.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: exerciseRecords.length,
              itemBuilder: (context, index) {
                final record = exerciseRecords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      '${record.exerciseType} - ${record.durationMinutes} min',
                    ),
                    subtitle: Text(
                      'Before: ${record.beforeBloodSugar?.toStringAsFixed(1) ?? 'N/A'}, After: ${record.afterBloodSugar?.toStringAsFixed(1) ?? 'N/A'} • ${record.createdAt.toString().split(' ')[0]}',
                    ),
                    onLongPress: () => _showEditDeleteMenu(context, record),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExerciseScreen()),
          );
          if (newRecord != null) {
            await _loadRecords();
          }
        },
        tooltip: 'Add Exercise Record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
