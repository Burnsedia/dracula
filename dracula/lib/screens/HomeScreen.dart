
import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import '../componets/sidebar.dart';
import "./AddBloodSugar.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BloodSugarLog> bloodSugarRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Sugar Tracker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bloodSugarRecords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Blood Sugar: ${bloodSugarRecords[index].bloodSugar} mg/dL',
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
            setState(() => bloodSugarRecords.add(newRecord));
          }
        },
        tooltip: 'Add Blood Sugar Record',
        child: const Icon(Icons.add),
      ),
    );
  } // <-- closes build()
}   // <-- closes _HomeScreenState

