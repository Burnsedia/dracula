import 'package:dracula/models/bloodsugar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/screens/HomeScreen.dart';
import 'package:dracula/screens/AddBloodSugar.dart';

void main() {
  group('HomeScreen - US-1.3 View History & US-4.2 Home Dashboard', () {
    testWidgets('should display empty list initially', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      expect(find.text('Blood Sugar Tracker'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should display blood sugar records in list', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      // Add a record via FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Enter a value and save
      await tester.enterText(find.byType(TextField), '120');
      await tester.tap(find.text('Save Record'));
      await tester.pumpAndSettle();

      // Check if the record is displayed
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Blood Sugar: 120.0 mg/dL'), findsOneWidget);
    });

    testWidgets('should add multiple records', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      // Add first record
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '100');
      await tester.tap(find.text('Save Record'));
      await tester.pumpAndSettle();

      // Add second record
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '110');
      await tester.tap(find.text('Save Record'));
      await tester.pumpAndSettle();

      // Check both records are displayed
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Blood Sugar: 100.0 mg/dL'), findsOneWidget);
      expect(find.text('Blood Sugar: 110.0 mg/dL'), findsOneWidget);
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