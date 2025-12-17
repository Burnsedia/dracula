
import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import '../services/database_helper.dart';
import '../componets/sidebar.dart';
import "./AddBloodSugar.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BloodSugarLog> bloodSugarRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final records = await DatabaseHelper.instance.readAll();
    setState(() {
      bloodSugarRecords = records;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Sugar Tracker'),
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
                          return ListTile(
                            title: Text(
                              'Blood Sugar: ${record.bloodSugar} mg/dL',
                            ),
                            subtitle: Text(
                              '${record.isBeforeMeal ? "Before" : "After"} meal • ${record.createdAt.toString().split(' ')[0]}',
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

