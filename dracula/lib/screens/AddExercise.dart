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

  final List<String> premadeExercises = [
    'Running',
    'Cycling',
    'Swimming',
    'Walking',
    'Yoga',
    'Pilates',
    'Weightlifting',
    'Bench Press',
    'Squats',
    'Deadlifts',
    'Push-ups',
    'Pull-ups',
    'Jumping Jacks',
    'Burpees',
    'Planks',
    'Sit-ups',
    'Lunges',
    'Bicep Curls',
    'Tricep Dips',
    'Shoulder Press',
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Premade Exercises',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: premadeExercises.map((exercise) {
                return ElevatedButton(
                  onPressed: () {
                    exerciseTypeController.text = exercise;
                  },
                  child: Text(exercise),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: exerciseTypeController,
              decoration: const InputDecoration(
                labelText: 'Exercise Type (or select from above)',
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
