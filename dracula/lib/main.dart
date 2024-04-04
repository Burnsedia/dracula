import 'package:flutter/material.dart';

void main() {
  runApp(BloodSugarApp());
}

class BloodSugarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dracula',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BloodSugarTrackerScreen(),
    );
  }
}

class BloodSugarTrackerScreen extends StatefulWidget {
  @override
  _BloodSugarTrackerScreenState createState() => _BloodSugarTrackerScreenState();
}

class _BloodSugarTrackerScreenState extends State<BloodSugarTrackerScreen> {
  List<Record> bloodSugarRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dracula'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the add record screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRecordScreen()),
              ).then((newRecord) {
                if (newRecord != null) {
                  setState(() {
                    bloodSugarRecords.add(newRecord);
                  });
                }
              });
            },
            child: Text('Add Blood Sugar Record'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bloodSugarRecords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Blood Sugar: ${bloodSugarRecords[index].bloodSugar} mg/dL'),
                  subtitle: Text('Carbs: ${bloodSugarRecords[index].carbs} grams'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



