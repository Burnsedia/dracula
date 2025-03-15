import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../componets/sidebar.dart";

class AddRecordScreen extends StatefulWidget {
  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  TextEditingController bloodSugarController = TextEditingController();
  TextEditingController carbsController = TextEditingController();

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
          children: [
            TextField(
              controller: bloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Blood Sugar (mg/dL)'),
            ),
            TextField(
              controller: carbsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Carbs (grams)'),
            ),
            ElevatedButton(
              onPressed: () {
                double bloodSugar = double.tryParse(bloodSugarController.text) ?? 0.0;
                int carbs = int.tryParse(carbsController.text) ?? 0;

                if (bloodSugar > 0.0 && carbs >= 0) {
                  Navigator.pop(
                    context,
                    Record(bloodSugar: bloodSugar, carbs: carbs),
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
    carbsController.dispose();
    super.dispose();
  }
}

