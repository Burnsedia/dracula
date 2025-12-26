import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../models/category.dart";
import "../models/meal.dart";
import "../models/exercise.dart";
import "../services/database_helper.dart";
import "../services/settings_service.dart";
import "package:flutter/material.dart";

class AddRecordScreen extends StatefulWidget {
  final BloodSugarLog? record;

  const AddRecordScreen({super.key, this.record});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  late TextEditingController bloodSugarController;
  late TimingType selectedTiming;
  int? selectedCategoryId;
  int? selectedMealId;
  List<Category> categories = [];
  List<Meal> meals = [];
  BloodSugarUnit _displayUnit = BloodSugarUnit.mgdl;

  @override
  void initState() {
    super.initState();
    _loadSettingsAndCategories();
    bloodSugarController = TextEditingController(
      text: widget.record != null
          ? SettingsService()
                .convertToDisplayUnit(widget.record!.bloodSugar, _displayUnit)
                .toString()
          : '',
    );
    selectedTiming = widget.record?.timingType ?? TimingType.beforeMeal;
    selectedCategoryId = widget.record?.categoryId;
    selectedMealId = widget.record?.mealId;
    // Note: workoutId not implemented in BloodSugarLog yet
  }

  Future<void> _loadSettingsAndCategories() async {
    final unit = await SettingsService().getBloodSugarUnit();
    final cats = await DatabaseHelper.instance.readAllCategories();
    final mealsList = await DatabaseHelper.instance.readAllMeals();
    setState(() {
      _displayUnit = unit;
      categories = cats;
      meals = mealsList;
    });

    if (widget.record != null) {
      final displayValue = SettingsService().convertToDisplayUnit(
        widget.record!.bloodSugar,
        unit,
      );
      bloodSugarController.text = displayValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.record != null
              ? 'Edit Blood Sugar Record'
              : 'Add Blood Sugar Record',
        ),
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
                labelText:
                    'Blood Sugar (${SettingsService().getUnitDisplayString(_displayUnit)})',
              ),
            ),
            DropdownButtonFormField<TimingType>(
              decoration: const InputDecoration(labelText: 'Timing'),
              value: selectedTiming,
              onChanged: (TimingType? newValue) {
                if (newValue != null) {
                  setState(() => selectedTiming = newValue);
                }
              },
              items: TimingType.values.map((TimingType timing) {
                String displayText;
                switch (timing) {
                  case TimingType.beforeMeal:
                    displayText = 'Before Meal';
                    break;
                  case TimingType.afterMeal:
                    displayText = 'After Meal';
                    break;
                  case TimingType.beforeExercise:
                    displayText = 'Before Exercise';
                    break;
                  case TimingType.afterExercise:
                    displayText = 'After Exercise';
                    break;
                  case TimingType.none:
                    displayText = 'No Specific Timing';
                    break;
                }
                return DropdownMenuItem<TimingType>(
                  value: timing,
                  child: Text(displayText),
                );
              }).toList(),
            ),
            if (categories.isNotEmpty)
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                ),
                value: selectedCategoryId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('No category'),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => selectedCategoryId = value),
              ),
            if (selectedTiming == TimingType.beforeMeal ||
                selectedTiming == TimingType.afterMeal) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Meal (optional)'),
                value: selectedMealId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('No meal selected'),
                  ),
                  ...meals.map(
                    (meal) => DropdownMenuItem<int>(
                      value: meal.id,
                      child: Text(meal.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => selectedMealId = value),
              ),
            ],
            ElevatedButton(
              onPressed: () async {
                final bloodSugar =
                    double.tryParse(bloodSugarController.text) ?? 0.0;

                if (bloodSugar > 0.0) {
                  debugPrint(
                    'Attempting to save blood sugar record with value: $bloodSugar, category: $selectedCategoryId, meal: $selectedMealId',
                  );
                  try {
                    final storageValue = SettingsService()
                        .convertFromDisplayUnit(bloodSugar, _displayUnit);

                    if (widget.record != null) {
                      final updatedRecord = widget.record!.copyWith(
                        bloodSugar: storageValue,
                        timingType: selectedTiming,
                        categoryId: selectedCategoryId,
                        mealId: selectedMealId,
                      );

                      await DatabaseHelper.instance.update(updatedRecord);
                      debugPrint('Blood sugar record updated successfully');
                      if (mounted) {
                        Navigator.pop(context, updatedRecord);
                      }
                    } else {
                      final newRecord = BloodSugarLog(
                        bloodSugar: storageValue,
                        isBeforeMeal: selectedTiming == TimingType.beforeMeal,
                        timingType: selectedTiming,
                        categoryId: selectedCategoryId,
                        mealId: selectedMealId,
                        createdAt: DateTime.now(),
                      );

                      final savedRecord = await DatabaseHelper.instance.create(
                        newRecord,
                      );
                      debugPrint(
                        'New blood sugar record created successfully with id: ${savedRecord.id}',
                      );
                      if (mounted) {
                        Navigator.pop(context, savedRecord);
                      }
                    }
                  } catch (e) {
                    debugPrint('Failed to save blood sugar record: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save record: $e')),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid blood sugar value.',
                        ),
                      ),
                    );
                  }
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
    bloodSugarController.dispose();
    super.dispose();
  }
}
