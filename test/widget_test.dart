// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:dracula/main.dart';
import 'package:dracula/screens/HomeScreen.dart';
import 'package:dracula/services/database_helper.dart';

void main() {
  setUp(() async {
    // Initialize sqflite for tests
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Mock SharedPreferences to disable app lock for tests
    SharedPreferences.setMockInitialValues({
      'app_lock_enabled': false,
      'onboarding_completed': true,
    });
    // Initialize database
    await DatabaseHelper.instance.database;
  });

  testWidgets('App builds', (WidgetTester tester) async {
    // Build our home screen directly with the Dracula theme to avoid lock screen async issues in tests
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFbd93f9),
        scaffoldBackgroundColor: const Color(0xFF282a36),
        cardColor: const Color(0xFF44475a),
      ),
      home: HomeScreen(),
    ));
    await tester.pumpAndSettle();

    // Verify that the home screen is present.
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
