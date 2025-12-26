import 'package:flutter/material.dart';
import "../models/meal.dart";
import "../services/database_helper.dart";
import "./AddMeal.dart";
import "./settings.dart";

class MealListScreen extends StatefulWidget {
  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  List<Meal> mealRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    if (mounted) setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.readAllMeals();
    if (mounted)
      setState(() {
        mealRecords = records;
        _isLoading = false;
      });
  }

  void _showEditDeleteMenu(BuildContext context, Meal record) {
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
                  _deleteRecord(record);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editRecord(Meal record) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMealScreen(record: record)),
    );
    if (result != null) {
      _loadRecords();
    }
  }

  void _deleteRecord(Meal record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text(
          'Are you sure you want to delete this meal record?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true && record.id != null) {
      await DatabaseHelper.instance.deleteMeal(record.id!);
      _loadRecords();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Meal deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
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
          : mealRecords.isEmpty
          ? const Center(child: Text('No meals logged yet'))
          : ListView.builder(
              itemCount: mealRecords.length,
              itemBuilder: (context, index) {
                final record = mealRecords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(record.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${record.dateTime.toLocal().toString().split(' ')[0]}',
                        ),
                        if (record.calories != null)
                          Text('Calories: ${record.calories}'),
                        if (record.carbs != null)
                          Text('Carbs: ${record.carbs}g'),
                        if (record.protein != null)
                          Text('Protein: ${record.protein}g'),
                        if (record.fat != null) Text('Fat: ${record.fat}g'),
                        if (record.bloodSugarAfter != null)
                          Text('Blood Sugar After: ${record.bloodSugarAfter}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showEditDeleteMenu(context, record),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealScreen()),
          );
          if (result != null) {
            _loadRecords();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
