import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/main.dart';
import 'package:dracula/models/category.dart';
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

  group('Category System Integration Test', () {
    testWidgets('US-Category-1: User can create and use meal categories',
        (WidgetTester tester) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      // Navigate to settings (where categories are managed)
      expect(find.byIcon(Icons.settings), findsOneWidget);
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Look for category management option
      expect(find.text('Categories'), findsOneWidget);
      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      // Should be on category management screen
      expect(find.text('Manage Categories'), findsOneWidget);

      // Create a meal category
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Breakfast');
      await tester.pumpAndSettle();

      // Select meal category type
      await tester.tap(find.text('General (Blood Sugar)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Meal Category'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Should show the meal category
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Meal'), findsOneWidget);
    });

    testWidgets('US-Category-2: Meal categories integrate with meal creation',
        (WidgetTester tester) async {
      // Create a meal category first
      final category = Category(name: 'Lunch', type: CategoryType.meal);
      await DatabaseHelper.instance.createCategory(category);

      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      // Navigate to meals
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
      await tester.tap(find.byIcon(Icons.restaurant));
      await tester.pumpAndSettle();

      // Add new meal
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter meal name
      await tester.enterText(
          find.byType(TextField).first, 'Grilled Chicken Salad');
      await tester.pumpAndSettle();

      // Check that category dropdown is available
      expect(find.text('Category (optional)'), findsOneWidget);

      // The category should be selectable (though we can't easily test the dropdown interaction in this integration test)
      // This verifies the UI includes category selection
    });

    testWidgets(
        'US-Category-3: Blood sugar logging shows meal selection when before meal',
        (WidgetTester tester) async {
      // Create a meal with category
      final category = Category(name: 'Dinner', type: CategoryType.meal);
      final createdCategory =
          await DatabaseHelper.instance.createCategory(category);

      final meal = await DatabaseHelper.instance.createMeal(
        Meal(
          name: 'Salmon with Vegetables',
          dateTime: DateTime.now(),
          categoryId: createdCategory.id,
          calories: 450.0,
        ),
      );

      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      // Add blood sugar reading
      expect(find.byIcon(Icons.add), findsOneWidget);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter blood sugar value
      await tester.enterText(find.byType(TextField).at(1), '110');
      await tester.pumpAndSettle();

      // Select "Before Meal"
      await tester.tap(find.text('After Meal'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Before Meal'));
      await tester.pumpAndSettle();

      // Should show meal selection
      expect(find.text('Meal (optional)'), findsOneWidget);

      // The meal should be available for selection
      // (Dropdown interaction is complex to test in integration tests)
    });

    testWidgets(
        'US-Category-4: Category system supports workout categorization',
        (WidgetTester tester) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      // Navigate to settings → Categories
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Categories'));
      await tester.pumpAndSettle();

      // Create workout category
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'HIIT');
      await tester.pumpAndSettle();

      // Select workout category type
      await tester.tap(find.text('General (Blood Sugar)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Workout Category'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Should show workout category
      expect(find.text('HIIT'), findsOneWidget);
      expect(find.text('Workout'), findsOneWidget);
    });
  });
}
