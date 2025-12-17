import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../services/database_helper.dart";
import "../services/settings_service.dart";
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
  BloodSugarUnit _displayUnit = BloodSugarUnit.mgdl;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    // Initialize with existing data if editing, or defaults if adding
    bloodSugarController = TextEditingController(
      text: widget.record != null
          ? SettingsService().convertToDisplayUnit(widget.record!.bloodSugar, _displayUnit).toString()
          : '',
    );
    isBeforeMeal = widget.record?.isBeforeMeal ?? true;
  }

  Future<void> _loadSettings() async {
    final unit = await SettingsService().getBloodSugarUnit();
    setState(() => _displayUnit = unit);

    // Update controller text if we have a record
    if (widget.record != null) {
      final displayValue = SettingsService().convertToDisplayUnit(widget.record!.bloodSugar, unit);
      bloodSugarController.text = displayValue.toString();
    }
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
           children: [
             TextField(
               controller: bloodSugarController,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                 labelText: 'Blood Sugar (${SettingsService().getUnitDisplayString(_displayUnit)})',
               ),
             ),

             Column(
               children: [
                 RadioListTile(
                   title: const Text("Before Meal"),
                   value: true,
                   groupValue: isBeforeMeal,
                   onChanged: (value) => setState(() => isBeforeMeal = value ?? true),
                 ),
                 RadioListTile(
                   title: const Text("After Meal"),
                   value: false,
                   groupValue: isBeforeMeal,
                   onChanged: (value) => setState(() => isBeforeMeal = value ?? false),
                 ),
               ],
             ),

              FilledButton(
                onPressed: () {
                  final bloodSugar = double.tryParse(bloodSugarController.text) ?? 0.0;

                  if (bloodSugar > 0.0) {
                    try {
                      // Convert from display units back to mg/dL for storage
                      final storageValue = SettingsService().convertFromDisplayUnit(bloodSugar, _displayUnit);

                      if (widget.record != null) {
                        // Update existing record
                        final updatedRecord = widget.record!.copyWith(
                          bloodSugar: storageValue,
                          isBeforeMeal: isBeforeMeal,
                        );

                        DatabaseHelper.instance.update(updatedRecord).then((_) {
                          if (mounted) {
                            Navigator.pop(context, updatedRecord);
                          }
                        });
                      } else {
                        // Create new record
                        final newRecord = BloodSugarLog(
                          bloodSugar: storageValue,
                          isBeforeMeal: isBeforeMeal,
                          createdAt: DateTime.now(),
                        );

                        DatabaseHelper.instance.create(newRecord).then((savedRecord) {
                          if (mounted) {
                            Navigator.pop(context, savedRecord);
                          }
                        });
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: const Text('Failed to save record. Please try again.'),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: const Text('Invalid input. Please enter valid values.'),
                      ),
                    );
                  }
                },
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(widget.record != null ? Icons.update : Icons.save),
                   const SizedBox(width: 8),
                   Text(widget.record != null ? 'Update Record' : 'Save Record'),
                 ],
               ),
              ),

           ],
         ),
       ),
     );

                       await DatabaseHelper.instance.update(updatedRecord);

                       if (mounted) {
                         Navigator.pop(context, updatedRecord);
                       }
                     } else {
                       // Create new record
                       final newRecord = BloodSugarLog(
                         bloodSugar: storageValue,
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
                           content: const Text('Failed to save record. Please try again.'),
                         ),
                       );
                     }
                   }
                 } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                       content: const Text('Invalid input. Please enter valid values.'),
                     ),
                   );
                 }
               },
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Icon(widget.record != null ? Icons.update : Icons.save),
                   const SizedBox(width: 8),
                   Text(widget.record != null ? 'Update Record' : 'Save Record'),
                 ],
               ),
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

