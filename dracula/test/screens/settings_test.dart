import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/screens/settings.dart';
import 'package:dracula/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    // Clear shared preferences before each test
    SharedPreferences.setMockInitialValues({});
    await SettingsService().clearAll();
  });

  tearDown(() async {
    await SettingsService().clearAll();
  });

  group('SettingsScreen - US-1.4 Units & Timezone', () {
    testWidgets('should display settings options', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Blood Sugar Units'), findsOneWidget);
      expect(find.text('Display'), findsOneWidget);
      // Scroll to see more sections
      await tester.scrollUntilVisible(find.text('Security'), 50);
      expect(find.text('Security'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Reminders'), 50);
      expect(find.text('Reminders'), findsOneWidget);
    });

    testWidgets('should allow changing blood sugar units',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      // Initially should be mg/dL
      expect(find.text('mg/dL (milligrams per deciliter)'), findsOneWidget);

      // Change to mmol/L
      await tester.tap(find.text('mmol/L (millimoles per liter)'));
      await tester.pumpAndSettle();

      // Verify setting was saved
      final unit = await SettingsService().getBloodSugarUnit();
      expect(unit, BloodSugarUnit.mmoll);

      // Verify snackbar message
      expect(find.text('Units changed to mmol/L'), findsOneWidget);
    });

    testWidgets('should toggle timezone display', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      // Find the timezone text
      expect(find.text('Show timezone in timestamps'), findsOneWidget);

      // Find the switch for timezone (first switch in Display section)
      final switches = find.byType(Switch);
      expect(switches, findsAtLeast(1));
      final switchFinder = switches.first;

      // Initially should be enabled
      Switch toggle = tester.widget(switchFinder);
      expect(toggle.value, true);

      // Toggle off
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      // Verify setting was saved
      final showTimezone = await SettingsService().getShowTimezone();
      expect(showTimezone, false);
    });

    testWidgets('should display about section', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      // Scroll to About section
      await tester.scrollUntilVisible(
          find.text('Dracula Blood Sugar Tracker'), 50);
      expect(find.text('Dracula Blood Sugar Tracker'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);
      expect(find.text('Privacy-focused health tracking app'), findsOneWidget);
    });
  });

  group('SettingsService', () {
    test('should convert between units correctly', () {
      final service = SettingsService();

      // mg/dL to mmol/L
      expect(service.convertToDisplayUnit(180.0, BloodSugarUnit.mmoll), 10.0);
      expect(service.convertToDisplayUnit(90.0, BloodSugarUnit.mmoll), 5.0);

      // mmol/L to mg/dL
      expect(service.convertFromDisplayUnit(10.0, BloodSugarUnit.mmoll), 180.0);
      expect(service.convertFromDisplayUnit(5.0, BloodSugarUnit.mmoll), 90.0);

      // Same unit should return same value
      expect(service.convertToDisplayUnit(120.0, BloodSugarUnit.mgdl), 120.0);
      expect(service.convertFromDisplayUnit(120.0, BloodSugarUnit.mgdl), 120.0);
    });

    test('should return correct unit display strings', () {
      final service = SettingsService();

      expect(service.getUnitDisplayString(BloodSugarUnit.mgdl), 'mg/dL');
      expect(service.getUnitDisplayString(BloodSugarUnit.mmoll), 'mmol/L');
    });

    test('should persist and retrieve settings', () async {
      final service = SettingsService();

      // Test unit setting
      await service.setBloodSugarUnit(BloodSugarUnit.mmoll);
      var unit = await service.getBloodSugarUnit();
      expect(unit, BloodSugarUnit.mmoll);

      await service.setBloodSugarUnit(BloodSugarUnit.mgdl);
      unit = await service.getBloodSugarUnit();
      expect(unit, BloodSugarUnit.mgdl);

      // Test timezone setting
      await service.setShowTimezone(false);
      var showTimezone = await service.getShowTimezone();
      expect(showTimezone, false);

      await service.setShowTimezone(true);
      showTimezone = await service.getShowTimezone();
      expect(showTimezone, true);
    });
  });
}
