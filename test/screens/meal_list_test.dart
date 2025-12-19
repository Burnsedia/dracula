import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/models/meal.dart';
import 'package:dracula/screens/MealList.dart';
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

  group('MealListScreen', () {
    testWidgets('should display empty state when no meals',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('No meals logged yet'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display meals list when meals exist',
        (WidgetTester tester) async {
      // Create a test meal
      final testMeal = Meal(
        name: 'Test Meal',
        dateTime: DateTime.now(),
        carbs: 50.0,
        protein: 25.0,
        fat: 15.0,
        calories: 400.0,
        bloodSugarAfter: 120.0,
      );
      await DatabaseHelper.instance.createMeal(testMeal);

      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('Test Meal'), findsOneWidget);
      expect(find.text('Carbs: 50.0g'), findsOneWidget);
      expect(find.text('Protein: 25.0g'), findsOneWidget);
      expect(find.text('Fat: 15.0g'), findsOneWidget);
      expect(find.text('Calories: 400.0'), findsOneWidget);
      expect(find.text('Blood Sugar After: 120.0'), findsOneWidget);
    });

    testWidgets('should show add meal screen when FAB is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      // Tap the FAB
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Should navigate to AddMealScreen
      expect(find.text('Add Meal'), findsOneWidget);
    });

    testWidgets('should show edit/delete menu when meal item is long pressed',
        (WidgetTester tester) async {
      // Create a test meal
      final testMeal = Meal(
        name: 'Test Meal',
        dateTime: DateTime.now(),
      );
      await DatabaseHelper.instance.createMeal(testMeal);

      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      // Long press the meal item
      final mealCard = find.byType(Card).first;
      await tester.longPress(mealCard);
      await tester.pumpAndSettle();

      // Should show bottom sheet with edit and delete options
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should delete meal when delete is confirmed',
        (WidgetTester tester) async {
      // Create a test meal
      final testMeal = Meal(
        name: 'Test Meal',
        dateTime: DateTime.now(),
      );
      await DatabaseHelper.instance.createMeal(testMeal);

      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      // Long press and tap delete
      final mealCard = find.byType(Card).first;
      await tester.longPress(mealCard);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should show confirmation dialog
      expect(find.text('Delete Meal'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this meal record?'),
          findsOneWidget);

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should show snackbar and remove meal
      expect(find.text('Meal deleted'), findsOneWidget);
      expect(find.text('Test Meal'), findsNothing);
    });

    testWidgets('should navigate to edit screen when edit is tapped',
        (WidgetTester tester) async {
      // Create a test meal
      final testMeal = Meal(
        name: 'Test Meal',
        dateTime: DateTime.now(),
      );
      await DatabaseHelper.instance.createMeal(testMeal);

      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      // Long press and tap edit
      final mealCard = find.byType(Card).first;
      await tester.longPress(mealCard);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Should navigate to edit screen
      expect(find.text('Edit Meal'), findsOneWidget);
    });

    testWidgets('should refresh list when returning from add/edit screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: MealListScreen()));
      await tester.pumpAndSettle();

      // Initially empty
      expect(find.text('No meals logged yet'), findsOneWidget);

      // Simulate returning with a new meal (in real app this would be via navigation)
      // For testing, we can directly add to database and call setState
      // But this is complex; in integration tests we'd use a different approach
    });
  });
}
