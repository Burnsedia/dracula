import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../services/database_helper.dart";
import "../componets/sidebar.dart";

class AddRecordScreen extends StatefulWidget {
  final BloodSugarLog? record;

  const AddRecordScreen({super.key, this.record});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  late TextEditingController bloodSugarController;
  late bool isBeforeMeal;

  @override
  void initState() {
    super.initState();
    // Initialize with existing data if editing, or defaults if adding
    bloodSugarController = TextEditingController(
      text: widget.record?.bloodSugar.toString() ?? '',
    );
    isBeforeMeal = widget.record?.isBeforeMeal ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record != null ? 'Edit Blood Sugar Record' : 'Add Blood Sugar Record'),
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
                },
              ),
            ],
            ),
            FilledButton.icon(
   onPressed: () async {
     final bloodSugar = double.tryParse(bloodSugarController.text) ?? 0.0;

     if (bloodSugar > 0.0) {
       try {
         if (widget.record != null) {
           // Update existing record
           final updatedRecord = widget.record!.copyWith(
             bloodSugar: bloodSugar,
             isBeforeMeal: isBeforeMeal,
           );

           await DatabaseHelper.instance.update(updatedRecord);

           if (mounted) {
             Navigator.pop(context, updatedRecord);
           }
         } else {
           // Create new record
           final newRecord = BloodSugarLog(
             bloodSugar: bloodSugar,
             isBeforeMeal: isBeforeMeal,
             createdAt: DateTime.now(),
           );

           final savedRecord = await DatabaseHelper.instance.create(newRecord);

           if (mounted) {
             Navigator.pop(context, savedRecord);
           }
         }
       } catch (e) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
               content: Text('Failed to save record. Please try again.'),
             ),
           );
         }
       }
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text('Invalid input. Please enter valid values.'),
         ),
       );
     }
   },
   icon: const Icon(widget.record != null ? Icons.update : Icons.save),
   label: Text(widget.record != null ? 'Update Record' : 'Save Record'),
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

