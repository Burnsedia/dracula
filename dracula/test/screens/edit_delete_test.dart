import 'package:dracula/models/bloodsugar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/screens/HomeScreen.dart';
import 'package:dracula/screens/AddBloodSugar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/services/database_helper.dart';
import 'package:path/path.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() async {
    // Ensure clean database for each test
    final dbPath = await getDatabasesPath();
    await deleteDatabase('$dbPath/dracula.db');
  });

  tearDown(() async {
    // Clean up after each test
    final dbPath = await getDatabasesPath();
    await deleteDatabase('$dbPath/dracula.db');
  });

  group('HomeScreen - US-1.2 Edit/Delete Entry', () {
    testWidgets('should show edit/delete options on long press', (WidgetTester tester) async {
      // Add a record to database first
      final testRecord = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );
      await DatabaseHelper.instance.create(testRecord);

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for database load

      // Long press on the record
      await tester.longPress(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Check for edit/delete options in bottom sheet
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should delete entry after confirmation', (WidgetTester tester) async {
      // Add a record to database first
      final testRecord = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );
      await DatabaseHelper.instance.create(testRecord);

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for database load

      // Verify record exists
      expect(find.byType(ListTile), findsOneWidget);

      // Long press and select delete
      await tester.longPress(find.byType(ListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify record is deleted and success message shown
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('Record deleted successfully'), findsOneWidget);
    });

    testWidgets('should allow editing an entry', (WidgetTester tester) async {
      // Add a record to database first
      final testRecord = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );
      final createdRecord = await DatabaseHelper.instance.create(testRecord);

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for database load

      // Long press and select edit
      await tester.longPress(find.byType(ListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Verify we're on the edit screen
      expect(find.text('Edit Blood Sugar Record'), findsOneWidget);

      // Verify form is pre-filled
      expect(find.text('120'), findsOneWidget); // Blood sugar value
      expect(find.text('Before Meal'), findsOneWidget); // Selected option

      // Change the value
      await tester.enterText(find.byType(TextField), '130');
      await tester.tap(find.text('After Meal'));
      await tester.tap(find.text('Update Record'));
      await tester.pumpAndSettle();

      // Verify we're back to home screen and record is updated
      expect(find.text('Blood Sugar: 130.0 mg/dL'), findsOneWidget);
      expect(find.text('After meal'), findsOneWidget);
    });
  });

  group('AddRecordScreen - Edit Mode', () {
    testWidgets('should pre-fill form with existing record data', (WidgetTester tester) async {
      final existingRecord = BloodSugarLog(
        id: 1,
        bloodSugar: 140.0,
        isBeforeMeal: false,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(MaterialApp(
        home: AddRecordScreen(record: existingRecord),
      ));

      // Verify app bar title
      expect(find.text('Edit Blood Sugar Record'), findsOneWidget);

      // Verify form is pre-filled
      expect(find.text('140'), findsOneWidget);
      expect(find.text('After Meal'), findsOneWidget);

      // Verify button text
      expect(find.text('Update Record'), findsOneWidget);
    });
  });
}