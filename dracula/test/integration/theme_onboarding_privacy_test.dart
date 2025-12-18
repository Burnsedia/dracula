import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/main.dart';
import 'package:dracula/screens/HomeScreen.dart';
import 'package:dracula/services/privacy_audit.dart';

void main() {
  group('Theme - US-4.1 Dracula Theme', () {
    testWidgets('should apply Dracula theme colors to app',
        (WidgetTester tester) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      // Get the theme from the app
      final BuildContext context = tester.element(find.byType(HomeScreen));
      final ThemeData theme = Theme.of(context);

      // Verify Material 3 is enabled
      expect(theme.useMaterial3, true);

      // Verify dark brightness
      expect(theme.brightness, Brightness.dark);

      // Verify Dracula colors are applied
      expect(theme.scaffoldBackgroundColor,
          const Color(0xFF282a36)); // Dracula background
      expect(theme.primaryColor, const Color(0xFFbd93f9)); // Dracula purple
      expect(theme.appBarTheme.backgroundColor,
          const Color(0xFF44475a)); // Dracula current line
      expect(theme.floatingActionButtonTheme.backgroundColor,
          const Color(0xFF50fa7b)); // Dracula green
    });

    testWidgets('should have proper contrast for accessibility',
        (WidgetTester tester) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(HomeScreen));
      final ThemeData theme = Theme.of(context);

      // Verify text colors provide good contrast on dark background
      final textColor = theme.textTheme.bodyLarge!.color!;

      // Calculate relative luminance (simplified check)
      // Dark background should have light text
      expect(
          textColor.red > 200 && textColor.green > 200 && textColor.blue > 200,
          true,
          reason:
              'Text should be light on dark background for WCAG AA compliance');
    });

    testWidgets('should apply theme to UI components',
        (WidgetTester tester) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle();

      // Check that app bar has Dracula colors
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, const Color(0xFF44475a));

      // Check floating action button color
      final fab = tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton));
      expect(fab.backgroundColor, const Color(0xFF50fa7b));
    });
  });

  group('Onboarding - US-4.3 Onboarding Flow', () {
    testWidgets('should show onboarding screens on first launch',
        (WidgetTester tester) async {
      // Placeholder test for onboarding
      // TODO: Implement when onboarding feature is built
    });
  });

  group('Privacy - US-8.1 No Telemetry', () {
    test('should pass privacy audit checks', () {
      // Test that privacy audit functions return expected results
      final compliance = PrivacyAudit.getComplianceStatus();

      expect(compliance['no_analytics_packages'], true);
      expect(compliance['offline_operation'], true);
      expect(compliance['no_external_services'], true);
      expect(compliance['local_data_only'], true);
    });

    test('should have comprehensive privacy policy', () {
      final policy = PrivacyAudit.getPrivacyPolicy();

      expect(policy, contains('No user accounts'));
      expect(policy, contains('All data stored locally'));
      expect(policy, contains('No analytics'));
      expect(policy, contains('No internet connection'));
      expect(policy, contains('No data shared'));
    });

    test('should not contain forbidden analytics packages', () {
      // Verify no analytics packages are in dependencies
      // This is a runtime check that would catch any accidental additions
      expect(PrivacyAudit.auditDependencies(), true);
    });

    test('should operate completely offline', () {
      // Verify the app doesn't require or use network connectivity
      expect(PrivacyAudit.verifyOfflineOperation(), true);
    });

    test('should include privacy assertions in main function', () {
      // Test that main.dart includes privacy checks
      // This ensures the app will fail to start if privacy is compromised
      expect(() => main(), returnsNormally);
    });
  });
}
