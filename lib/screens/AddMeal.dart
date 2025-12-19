import 'package:flutter/material.dart';
import "../models/meal.dart";
import "../models/category.dart";
import "../services/database_helper.dart";

class AddMealScreen extends StatefulWidget {
  final Meal? record;

  const AddMealScreen({super.key, this.record});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  late TextEditingController nameController;
  late TextEditingController carbsController;
  late TextEditingController proteinController;
  late TextEditingController fatController;
  late TextEditingController caloriesController;
  late TextEditingController fiberController;
  late TextEditingController sugarController;
  late TextEditingController sodiumController;
  late TextEditingController vitaminCController;
  late TextEditingController calciumController;
  late TextEditingController ironController;
  late TextEditingController bloodSugarBeforeController;
  late TextEditingController bloodSugarAfterController;

  DateTime selectedDateTime = DateTime.now();
  int? selectedCategoryId;
  List<Category> mealCategories = [];

  final List<String> premadeMeals = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
    'Apple',
    'Banana',
    'Chicken Breast',
    'Rice',
    'Bread',
    'Salad',
  ];

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.record?.dateTime ?? DateTime.now();
    selectedCategoryId = widget.record?.categoryId;
    nameController = TextEditingController(text: widget.record?.name ?? '');
    carbsController =
        TextEditingController(text: widget.record?.carbs?.toString() ?? '');
    proteinController =
        TextEditingController(text: widget.record?.protein?.toString() ?? '');
    fatController =
        TextEditingController(text: widget.record?.fat?.toString() ?? '');
    caloriesController =
        TextEditingController(text: widget.record?.calories?.toString() ?? '');
    fiberController =
        TextEditingController(text: widget.record?.fiber?.toString() ?? '');
    sugarController =
        TextEditingController(text: widget.record?.sugar?.toString() ?? '');
    sodiumController =
        TextEditingController(text: widget.record?.sodium?.toString() ?? '');
    vitaminCController =
        TextEditingController(text: widget.record?.vitaminC?.toString() ?? '');
    calciumController =
        TextEditingController(text: widget.record?.calcium?.toString() ?? '');
    ironController =
        TextEditingController(text: widget.record?.iron?.toString() ?? '');
    bloodSugarBeforeController = TextEditingController(
        text: widget.record?.bloodSugarBefore?.toString() ?? '');
    bloodSugarAfterController = TextEditingController(
        text: widget.record?.bloodSugarAfter?.toString() ?? '');
    _loadMealCategories();
  }

  Future<void> _loadMealCategories() async {
    final allCategories = await DatabaseHelper.instance.readAllCategories();
    setState(() {
      mealCategories =
          allCategories.where((cat) => cat.type == CategoryType.meal).toList();
    });
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record != null ? 'Edit Meal' : 'Add Meal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Premade Meals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: premadeMeals.map((meal) {
                return ElevatedButton(
                  onPressed: () => nameController.text = meal,
                  child: Text(meal),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Meal Name'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date & Time'),
              subtitle: Text(selectedDateTime.toLocal().toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration:
                  const InputDecoration(labelText: 'Category (optional)'),
              value: selectedCategoryId,
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('No category'),
                ),
                ...mealCategories.map((category) => DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    )),
              ],
              onChanged: (value) => setState(() => selectedCategoryId = value),
            ),
            const SizedBox(height: 16),
            const Text('Macros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories (kcal)'),
            ),
            TextField(
              controller: carbsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Carbohydrates (g)'),
            ),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Protein (g)'),
            ),
            TextField(
              controller: fatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Fat (g)'),
            ),
            const SizedBox(height: 16),
            const Text('Micros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: fiberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Fiber (g)'),
            ),
            TextField(
              controller: sugarController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sugar (g)'),
            ),
            TextField(
              controller: sodiumController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sodium (mg)'),
            ),
            TextField(
              controller: vitaminCController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Vitamin C (mg)'),
            ),
            TextField(
              controller: calciumController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calcium (mg)'),
            ),
            TextField(
              controller: ironController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Iron (mg)'),
            ),
            const SizedBox(height: 16),
            const Text('Blood Sugar Correlation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: bloodSugarBeforeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Blood Sugar Before (optional)'),
            ),
            TextField(
              controller: bloodSugarAfterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Blood Sugar After (optional)'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final name = nameController.text;
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a meal name')),
                  );
                  return;
                }

                final meal = Meal(
                  id: widget.record?.id,
                  name: name,
                  dateTime: selectedDateTime,
                  categoryId: selectedCategoryId,
                  carbs: double.tryParse(carbsController.text),
                  protein: double.tryParse(proteinController.text),
                  fat: double.tryParse(fatController.text),
                  calories: double.tryParse(caloriesController.text),
                  fiber: double.tryParse(fiberController.text),
                  sugar: double.tryParse(sugarController.text),
                  sodium: double.tryParse(sodiumController.text),
                  vitaminC: double.tryParse(vitaminCController.text),
                  calcium: double.tryParse(calciumController.text),
                  iron: double.tryParse(ironController.text),
                  bloodSugarBefore:
                      double.tryParse(bloodSugarBeforeController.text),
                  bloodSugarAfter:
                      double.tryParse(bloodSugarAfterController.text),
                );

                try {
                  if (widget.record != null) {
                    await DatabaseHelper.instance.updateMeal(meal);
                    if (mounted) Navigator.pop(context, meal);
                  } else {
                    final saved =
                        await DatabaseHelper.instance.createMeal(meal);
                    if (mounted) Navigator.pop(context, saved);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error saving meal: $e')),
                    );
                  }
                }
              },
              child: const Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    fatController.dispose();
    caloriesController.dispose();
    fiberController.dispose();
    sugarController.dispose();
    sodiumController.dispose();
    vitaminCController.dispose();
    calciumController.dispose();
    ironController.dispose();
    bloodSugarBeforeController.dispose();
    bloodSugarAfterController.dispose();
    super.dispose();
  }
}
