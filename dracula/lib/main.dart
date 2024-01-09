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




