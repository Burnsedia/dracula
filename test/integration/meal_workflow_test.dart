import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/main.dart';
import 'package:dracula/models/meal.dart';
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

  group('Meal Workflow Integration Test', () {
    testWidgets('US-Meal-1: User can add a new meal with nutrients', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Navigate to meals via bottom nav
      expect(find.text('Meals'), findsOneWidget);
      await tester.tap(find.text('Meals'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Should be on meal list screen
      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('No meals logged yet'), findsOneWidget);

      // Tap add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Should be on add meal screen
      expect(find.text('Add Meal'), findsOneWidget);

      // Fill in meal details
      await tester.enterText(find.byType(TextField).first, 'Breakfast Burrito');
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Enter nutrients
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(1), '450'); // Calories
      await tester.enterText(textFields.at(2), '45'); // Carbs
      await tester.enterText(textFields.at(3), '20'); // Protein
      await tester.enterText(textFields.at(4), '18'); // Fat
      await tester.enterText(textFields.at(5), '3'); // Fiber
      await tester.enterText(textFields.at(6), '2'); // Sugar
      await tester.enterText(textFields.at(7), '650'); // Sodium
      await tester.enterText(textFields.at(8), '15'); // Vitamin C
      await tester.enterText(textFields.at(9), '150'); // Calcium
      await tester.enterText(textFields.at(10), '3'); // Iron
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Save the meal
      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Should return to meal list
      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('Breakfast Burrito'), findsOneWidget);
      expect(find.text('Calories: 450.0'), findsOneWidget);
      expect(find.text('Carbs: 45.0g'), findsOneWidget);
    });

    testWidgets('US-Meal-2: User can edit an existing meal', (
      WidgetTester tester,
    ) async {
      // First create a meal
      final testMeal = Meal(
        name: 'Lunch Salad',
        dateTime: DateTime.now(),
        calories: 300.0,
        carbs: 20.0,
        protein: 15.0,
      );
      await DatabaseHelper.instance.createMeal(testMeal);

      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Navigate to meals via bottom nav
      await tester.tap(find.text('Meals'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Long press the meal to edit
      final mealCard = find.byType(Card).first;
      await tester.longPress(mealCard);
      await tester.pumpAndSettle(const Duration(seconds: 120));

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Should be on edit screen
      expect(find.text('Edit Meal'), findsOneWidget);

      // Update the name
      final nameField = find.byType(TextField).first;
      await tester.enterText(nameField, 'Updated Lunch Salad');
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Save changes
      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Should show updated meal
      expect(find.text('Updated Lunch Salad'), findsOneWidget);
    });

    testWidgets('US-Meal-3: User can delete a meal', (
      WidgetTester tester,
    ) async {
      // First create a meal
      final testMeal = Meal(
        name: 'Snack',
        dateTime: DateTime.now(),
        calories: 150.0,
      );
      await DatabaseHelper.instance.createMeal(testMeal);

      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Navigate to meals
      await tester.tap(find.byIcon(Icons.restaurant));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Long press to delete
      final mealCard = find.byType(Card).first;
      await tester.longPress(mealCard);
      await tester.pumpAndSettle(const Duration(seconds: 120));

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Should show empty state
      expect(find.text('No meals logged yet'), findsOneWidget);
      expect(find.text('Snack'), findsNothing);
    });

    testWidgets('US-Meal-4: Meal data correlates with blood sugar trends', (
      WidgetTester tester,
    ) async {
      // This would require more complex setup to test correlations
      // For now, just verify meals can be logged with blood sugar data

      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Navigate to meals
      await tester.tap(find.byIcon(Icons.restaurant));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Add a meal with blood sugar data
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      await tester.enterText(find.byType(TextField).first, 'High Carb Meal');
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Enter blood sugar values
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(11), '95'); // Before
      await tester.enterText(textFields.at(12), '140'); // After
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Save
      await tester.tap(find.text('Save Meal'));
      await tester.pumpAndSettle(const Duration(seconds: 120));

      // Verify blood sugar data is displayed
      expect(find.text('Blood Sugar After: 140.0'), findsOneWidget);
    });
  });
}
