import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../componets/sidebar.dart";

class AddRecordScreen extends StatefulWidget {
  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  TextEditingController bloodSugarController = TextEditingController();
  final bool isBeforeMeal; // true = Before Meal, false = After Meal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Blood Sugar Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ TextField(
              controller: bloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Blood Sugar (mg/dL)'),
            ),
        
            Column(
              children: [
                RadioListTile<bool>(
                  title: Text("Before Meal"),
                  value: true,
                  groupValue: isBeforeMeal,
                  onChanged: (bool? value) {
                  setState(() {
                   isBeforeMeal = value!;
                 });
               },
              ),
               RadioListTile<bool>(
                 title: Text("After Meal"),
                 value: false,
                 groupValue: isBeforeMeal,
                 onChanged: (bool? value) {
                  setState(() {
                   isBeforeMeal = value!;
                 });
               },
             ),
            ],
            ),
            ElevatedButton(
              onPressed: () {
                double bloodSugar = double.tryParse(bloodSugarController.text) ?? 0.0;

                if (bloodSugar > 0.0 ) {
                  Navigator.pop(
                    context,
                    BloodSugarLog(bloodSugar: bloodSugar, isBeforeMeal: isBeforeMeal, createdAt: DateTime.now()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid input. Please enter valid values.'),
                    ),
                  );
                }
              },
              child: Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloodSugarController.dispose();
    super.dispose();
  }
}

