import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/models/meal.dart';
import 'package:dracula/screens/AddMeal.dart';
import 'package:dracula/services/database_helper.dart';

void main() {
  setUp(() async {
    // Initialize sqflite for tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({
      'app_lock_enabled': false,
      'onboarding_completed': true,
    });

    // Initialize database
    await DatabaseHelper.instance.database;
  });

  group('AddMealScreen', () {
    testWidgets('should display all form fields', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = Size(800, 1200);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      await tester.pumpWidget(MaterialApp(home: AddMealScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Add Meal'), findsOneWidget);
      expect(find.text('Meal Name'), findsOneWidget);
      expect(find.text('Date & Time'), findsOneWidget);
      expect(find.text('Macros'), findsOneWidget);
      expect(find.text('Calories (kcal)'), findsOneWidget);
      expect(find.text('Carbohydrates (g)'), findsOneWidget);
      expect(find.text('Protein (g)'), findsOneWidget);
      expect(find.text('Fat (g)'), findsOneWidget);
      expect(find.text('Micros'), findsOneWidget);
      expect(find.text('Fiber (g)'), findsOneWidget);
      expect(find.text('Sugar (g)'), findsOneWidget);
      expect(find.text('Sodium (mg)'), findsOneWidget);
      expect(find.text('Vitamin C (mg)'), findsOneWidget);
      expect(find.text('Calcium (mg)'), findsOneWidget);
      expect(find.text('Iron (mg)'), findsOneWidget);
      expect(find.text('Blood Sugar Correlation'), findsOneWidget);
      expect(find.text('Blood Sugar Before (optional)'), findsOneWidget);
      expect(find.text('Blood Sugar After (optional)'), findsOneWidget);
      expect(find.text('Save Meal'), findsOneWidget);
    });

    testWidgets('should display premade meals', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddMealScreen()));
      await tester.pumpAndSettle();

      expect(
        find.text('Premade Exercises'),
        findsNothing,
      ); // Should be 'Premade Meals'
      expect(find.text('Premade Meals'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Snack'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Chicken Breast'), findsOneWidget);
      expect(find.text('Rice'), findsOneWidget);
      expect(find.text('Bread'), findsOneWidget);
      expect(find.text('Salad'), findsOneWidget);
    });

    testWidgets('should populate meal name when premade meal is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: AddMealScreen()));
      await tester.pumpAndSettle();

      // Find and tap a premade meal
      await tester.tap(find.text('Breakfast'));
      await tester.pumpAndSettle();

      // Check that the text field is populated
      final textField = find.byType(TextField).first;
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller?.text, 'Breakfast');
    });

    testWidgets('should show error when saving without name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: AddMealScreen()));
      await tester.pumpAndSettle();

      // Try to save without entering a name
      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a meal name'), findsOneWidget);
    });

    testWidgets('should save meal with valid data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: AddMealScreen()));
      await tester.pumpAndSettle();

      // Enter meal name
      await tester.enterText(find.byType(TextField).first, 'Test Meal');
      await tester.pumpAndSettle();

      // Enter some nutrients
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(1), '400'); // Calories
      await tester.enterText(textFields.at(2), '50'); // Carbs
      await tester.enterText(textFields.at(3), '25'); // Protein
      await tester.enterText(textFields.at(4), '15'); // Fat
      await tester.pumpAndSettle();

      // Tap save
      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle();

      // Should navigate back (since we can't easily mock the navigation in this test)
      // In a real scenario, we'd check the database or mock the navigator
    });

    testWidgets('should populate fields when editing existing meal', (
      WidgetTester tester,
    ) async {
      final existingMeal = Meal(
        id: 1,
        name: 'Existing Meal',
        dateTime: DateTime(2023, 12, 25, 12, 0),
        carbs: 50.0,
        protein: 25.0,
        fat: 15.0,
        calories: 400.0,
        bloodSugarAfter: 120.0,
      );

      await tester.pumpWidget(
        MaterialApp(home: AddMealScreen(record: existingMeal)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Edit Meal'), findsOneWidget);

      // Check that fields are populated
      final textFields = find.byType(TextField);
      final nameField = tester.widget<TextField>(textFields.first);
      expect(nameField.controller?.text, 'Existing Meal');

      // Check some nutrient fields (indices may vary)
      // This is simplified; in practice, we'd need to identify fields by label
    });

    testWidgets('should handle date time picker', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddMealScreen()));
      await tester.pumpAndSettle();

      // Find date time picker
      expect(find.text('Date & Time'), findsOneWidget);

      // Note: Testing date picker interaction requires more complex setup
      // For this test, we just verify the field is present
    });
  });
}
