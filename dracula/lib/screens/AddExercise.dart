import 'package:flutter/material.dart';
import "../models/exercise.dart";
import "../services/database_helper.dart";

class AddExerciseScreen extends StatefulWidget {
  final ExerciseLog? record;

  const AddExerciseScreen({super.key, this.record});

  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  late TextEditingController exerciseTypeController;
  late TextEditingController durationController;
  late TextEditingController beforeBloodSugarController;
  late TextEditingController afterBloodSugarController;

  @override
  void initState() {
    super.initState();
    exerciseTypeController = TextEditingController(
      text: widget.record?.exerciseType ?? '',
    );
    durationController = TextEditingController(
      text: widget.record?.durationMinutes.toString() ?? '',
    );
    beforeBloodSugarController = TextEditingController(
      text: widget.record?.beforeBloodSugar?.toString() ?? '',
    );
    afterBloodSugarController = TextEditingController(
      text: widget.record?.afterBloodSugar?.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record != null
            ? 'Edit Exercise Record'
            : 'Add Exercise Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: exerciseTypeController,
              decoration: const InputDecoration(
                labelText: 'Exercise Type',
              ),
            ),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Duration (minutes)',
              ),
            ),
            TextField(
              controller: beforeBloodSugarController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Blood Sugar Before (optional)',
              ),
            ),
            TextField(
              controller: afterBloodSugarController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Blood Sugar After (optional)',
              ),
            ),
            FilledButton(
              onPressed: () {
                final exerciseType = exerciseTypeController.text;
                final duration = int.tryParse(durationController.text) ?? 0;
                final beforeBloodSugar =
                    beforeBloodSugarController.text.isNotEmpty
                        ? double.tryParse(beforeBloodSugarController.text)
                        : null;
                final afterBloodSugar =
                    afterBloodSugarController.text.isNotEmpty
                        ? double.tryParse(afterBloodSugarController.text)
                        : null;

                if (exerciseType.isNotEmpty && duration > 0) {
                  try {
                    if (widget.record != null) {
                      final updatedRecord = widget.record!.copyWith(
                        exerciseType: exerciseType,
                        durationMinutes: duration,
                        beforeBloodSugar: beforeBloodSugar,
                        afterBloodSugar: afterBloodSugar,
                      );

                      DatabaseHelper.instance
                          .updateExercise(updatedRecord)
                          .then((_) {
                        if (mounted) {
                          Navigator.pop(context, updatedRecord);
                        }
                      });
                    } else {
                      final newRecord = ExerciseLog(
                        exerciseType: exerciseType,
                        durationMinutes: duration,
                        beforeBloodSugar: beforeBloodSugar,
                        afterBloodSugar: afterBloodSugar,
                        createdAt: DateTime.now(),
                      );

                      DatabaseHelper.instance
                          .createExercise(newRecord)
                          .then((savedRecord) {
                        if (mounted) {
                          Navigator.pop(context, savedRecord);
                        }
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text(
                              'Failed to save record. Please try again.'),
                        ),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: const Text(
                          'Invalid input. Please enter valid values.'),
                    ),
                  );
                }
              },
              child: const Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    exerciseTypeController.dispose();
    durationController.dispose();
    beforeBloodSugarController.dispose();
    afterBloodSugarController.dispose();
    super.dispose();
  }
}
