import 'package:dracula/models/bloodsugar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/screens/HomeScreen.dart';
import 'package:dracula/screens/AddBloodSugar.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should display a list of blood sugar records', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      // Initially, there are no records
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);

      // Add a record
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
  });

  group('AddRecordScreen', () {
    testWidgets('should create a new blood sugar record', (WidgetTester tester) async {
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
    });

    testWidgets('should show an error for invalid input', (WidgetTester tester) async {
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
  });
}