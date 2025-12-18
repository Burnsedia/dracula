import 'package:flutter/material.dart';
import "../models/bloodsugar.dart";
import "../models/category.dart";
import "../services/database_helper.dart";
import "../services/settings_service.dart";

class AddRecordScreen extends StatefulWidget {
  final BloodSugarLog? record;

  const AddRecordScreen({super.key, this.record});

  @override
  _AddRecordScreenState createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  late TextEditingController bloodSugarController;
  late bool isBeforeMeal;
  int? selectedCategoryId;
  List<Category> categories = [];
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
    isBeforeMeal = widget.record?.isBeforeMeal ?? true;
    selectedCategoryId = widget.record?.categoryId;
  }

  Future<void> _loadSettingsAndCategories() async {
    final unit = await SettingsService().getBloodSugarUnit();
    final cats = await DatabaseHelper.instance.readAllCategories();
    setState(() {
      _displayUnit = unit;
      categories = cats;
    });

    if (widget.record != null) {
      final displayValue = SettingsService()
          .convertToDisplayUnit(widget.record!.bloodSugar, unit);
      bloodSugarController.text = displayValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record != null
            ? 'Edit Blood Sugar Record'
            : 'Add Blood Sugar Record'),
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
            Column(
              children: [
                RadioListTile(
                  title: const Text("Before Meal"),
                  value: true,
                  groupValue: isBeforeMeal,
                  onChanged: (value) =>
                      setState(() => isBeforeMeal = value ?? true),
                ),
                RadioListTile(
                  title: const Text("After Meal"),
                  value: false,
                  groupValue: isBeforeMeal,
                  onChanged: (value) =>
                      setState(() => isBeforeMeal = value ?? false),
                ),
              ],
            ),
            if (categories.isNotEmpty)
              DropdownButtonFormField<int>(
                decoration:
                    const InputDecoration(labelText: 'Category (optional)'),
                value: selectedCategoryId,
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('No category'),
                  ),
                  ...categories.map((category) => DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      )),
                ],
                onChanged: (value) =>
                    setState(() => selectedCategoryId = value),
              ),
            FilledButton(
              onPressed: () async {
                final bloodSugar =
                    double.tryParse(bloodSugarController.text) ?? 0.0;

                if (bloodSugar > 0.0) {
                  try {
                    final storageValue = SettingsService()
                        .convertFromDisplayUnit(bloodSugar, _displayUnit);

                    if (widget.record != null) {
                      final updatedRecord = widget.record!.copyWith(
                        bloodSugar: storageValue,
                        isBeforeMeal: isBeforeMeal,
                        categoryId: selectedCategoryId,
                      );

                      await DatabaseHelper.instance.update(updatedRecord);
                      if (mounted) {
                        Navigator.pop(context, updatedRecord);
                      }
                    } else {
                      final newRecord = BloodSugarLog(
                        bloodSugar: storageValue,
                        isBeforeMeal: isBeforeMeal,
                        categoryId: selectedCategoryId,
                        createdAt: DateTime.now(),
                      );

                      final savedRecord =
                          await DatabaseHelper.instance.create(newRecord);
                      if (mounted) {
                        Navigator.pop(context, savedRecord);
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save record: $e'),
                        ),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Please enter a valid blood sugar value.'),
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
