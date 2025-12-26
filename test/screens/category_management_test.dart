import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/models/category.dart';
import 'package:dracula/screens/CategoryManagement.dart';
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

  group('CategoryManagementScreen', () {
    testWidgets('should display category types in dropdown', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: CategoryManagementScreen()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Manage Categories'), findsOneWidget);

      // Tap add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      expect(find.text('Add Category'), findsOneWidget);

      // Check that all category types are available
      expect(find.text('General (Blood Sugar)'), findsOneWidget);
      expect(find.text('Meal Category'), findsOneWidget);
      expect(find.text('Workout Category'), findsOneWidget);
    });

    testWidgets('should create meal category successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: CategoryManagementScreen()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Initially should show empty state
      expect(find.text('No custom categories yet.'), findsOneWidget);

      // Tap add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Fill in category details
      await tester.enterText(find.byType(TextField).first, 'High Protein');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Select meal category type
      await tester.tap(find.text('General (Blood Sugar)'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.text('Meal Category'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Save category
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should show the new category
      expect(find.text('High Protein'), findsOneWidget);
      expect(find.text('Meal'), findsOneWidget);
    });

    testWidgets('should create workout category successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: CategoryManagementScreen()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Tap add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Fill in category details
      await tester.enterText(find.byType(TextField).first, 'Strength Training');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Select workout category type
      await tester.tap(find.text('General (Blood Sugar)'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await tester.tap(find.text('Workout Category'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Save category
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should show the new category
      expect(find.text('Strength Training'), findsOneWidget);
      expect(find.text('Workout'), findsOneWidget);
    });

    testWidgets('should display different category types with correct labels', (
      WidgetTester tester,
    ) async {
      // Create categories of different types
      final generalCat = Category(name: 'Fasting', type: CategoryType.general);
      final mealCat = Category(name: 'Breakfast', type: CategoryType.meal);
      final workoutCat = Category(name: 'Cardio', type: CategoryType.workout);

      await DatabaseHelper.instance.createCategory(generalCat);
      await DatabaseHelper.instance.createCategory(mealCat);
      await DatabaseHelper.instance.createCategory(workoutCat);

      await tester.pumpWidget(MaterialApp(home: CategoryManagementScreen()));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Should show all categories with their type labels
      expect(find.text('Fasting'), findsOneWidget);
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Cardio'), findsOneWidget);

      // Check type labels
      expect(find.text('General'), findsOneWidget);
      expect(find.text('Meal'), findsOneWidget);
      expect(find.text('Workout'), findsOneWidget);
    });
  });
}
