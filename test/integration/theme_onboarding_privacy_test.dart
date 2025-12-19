import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dracula/main.dart';
import 'package:dracula/screens/HomeScreen.dart';

void main() {
  group('Theme - US-4.1 Dracula Theme', () {
    testWidgets('should apply Dracula theme colors to app', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Get the theme from the app
      final BuildContext context = tester.element(find.byType(HomeScreen));
      final ThemeData theme = Theme.of(context);

      // Verify Material 3 is enabled
      expect(theme.useMaterial3, true);

      // Verify dark brightness
      expect(theme.brightness, Brightness.dark);

      // Verify Dracula colors are applied
      expect(
        theme.scaffoldBackgroundColor,
        const Color(0xFF282a36),
      ); // Dracula background
      expect(theme.primaryColor, const Color(0xFFbd93f9)); // Dracula purple
      expect(
        theme.appBarTheme.backgroundColor,
        const Color(0xFF44475a),
      ); // Dracula current line
      expect(
        theme.floatingActionButtonTheme.backgroundColor,
        const Color(0xFF50fa7b),
      ); // Dracula green
    });

    testWidgets('should have proper contrast for accessibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 10));

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
            'Text should be light on dark background for WCAG AA compliance',
      );
    });

    testWidgets('should apply theme to UI components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(BloodSugarApp(onboardingCompleted: true));
      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Check that app bar has Dracula colors
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, const Color(0xFF44475a));

      // Check floating action button color
      final fab = tester.widget<FloatingActionButton>(
        find.byType(FloatingActionButton),
      );
      expect(fab.backgroundColor, const Color(0xFF50fa7b));
    });
  });

  group('Onboarding - US-4.3 Onboarding Flow', () {
    testWidgets('should show onboarding screens on first launch', (
      WidgetTester tester,
    ) async {
      // Placeholder test for onboarding
      // TODO: Implement when onboarding feature is built
    });
  });
}
