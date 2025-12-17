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

  group('HomeScreen - US-1.3 View History & US-4.2 Home Dashboard', () {
    testWidgets('should display empty list initially', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for database load

      expect(find.text('Blood Sugar Tracker'), findsOneWidget);
      expect(find.text('No blood sugar records yet'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should display blood sugar records in list', (WidgetTester tester) async {
      // Add a record to database first
      final testRecord = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );
      await DatabaseHelper.instance.create(testRecord);

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for database load

      // Check if the record is displayed
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Blood Sugar: 120.0 mg/dL'), findsOneWidget);
      expect(find.text('Before meal'), findsOneWidget);
    });

    testWidgets('should add multiple records', (WidgetTester tester) async {
      // Add records to database first
      final record1 = BloodSugarLog(bloodSugar: 100.0, isBeforeMeal: true, createdAt: DateTime.now());
      final record2 = BloodSugarLog(bloodSugar: 110.0, isBeforeMeal: false, createdAt: DateTime.now());
      await DatabaseHelper.instance.create(record1);
      await DatabaseHelper.instance.create(record2);

      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for database load

      // Check both records are displayed
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Blood Sugar: 100.0 mg/dL'), findsOneWidget);
      expect(find.text('Blood Sugar: 110.0 mg/dL'), findsOneWidget);
      expect(find.text('Before meal'), findsOneWidget);
      expect(find.text('After meal'), findsOneWidget);
    });
  });

  group('AddRecordScreen - US-1.1 Create Blood Sugar Entry', () {
    testWidgets('should create a new blood sugar record with valid input', (WidgetTester tester) async {
      BloodSugarLog? newRecord;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              newRecord = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRecordScreen()),
              );
            },
            child: const Text('Go'),
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Enter a value
      await tester.enterText(find.byType(TextField), '140');

      // Select "After Meal"
      await tester.tap(find.text('After Meal'));
      await tester.pump();

      // Save the record
      await tester.tap(find.text('Save Record'));
      await tester.pumpAndSettle();

      expect(newRecord, isNotNull);
      expect(newRecord?.id, isNotNull);
      expect(newRecord?.bloodSugar, 140.0);
      expect(newRecord?.isBeforeMeal, false);
      expect(newRecord?.createdAt, isA<DateTime>());
    });

    testWidgets('should default to before meal', (WidgetTester tester) async {
      BloodSugarLog? newRecord;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              newRecord = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRecordScreen()),
              );
            },
            child: const Text('Go'),
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Enter a value without changing meal type
      await tester.enterText(find.byType(TextField), '130');

      // Save the record
      await tester.tap(find.text('Save Record'));
      await tester.pumpAndSettle();

      expect(newRecord?.isBeforeMeal, true); // Default
    });

    testWidgets('should show error for invalid input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddRecordScreen()));

      // Enter an invalid value
      await tester.enterText(find.byType(TextField), 'abc');

      // Save the record
      await tester.tap(find.text('Save Record'));
      await tester.pump();

      // Check for the error message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Invalid input. Please enter valid values.'), findsOneWidget);
    });

    testWidgets('should show error for zero or negative values', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddRecordScreen()));

      // Enter zero
      await tester.enterText(find.byType(TextField), '0');

      // Save the record
      await tester.tap(find.text('Save Record'));
      await tester.pump();

      // Check for the error message
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}