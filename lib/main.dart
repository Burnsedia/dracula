import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "./screens/HomeScreen.dart";
import "./screens/onboarding.dart";
import "./screens/app_lock_screen.dart";
import "./services/privacy_audit.dart";
import "./services/notification_service.dart";
import "./services/database_helper.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await NotificationService().init();
  // Initialize database early to ensure schema is ready
  await DatabaseHelper.instance.database;

  // Privacy audit: Ensure no telemetry or tracking
  assert(PrivacyAudit.auditDependencies(),
      'Privacy violation: Forbidden analytics packages detected');

  // Check if onboarding is completed
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(BloodSugarApp(onboardingCompleted: onboardingCompleted));
}

class BloodSugarApp extends StatelessWidget {
  final bool onboardingCompleted;

  const BloodSugarApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dracula',
      theme: _buildDraculaTheme(),
      home: AppLockScreen(
        child: onboardingCompleted ? HomeScreen() : OnboardingScreen(),
      ),
    );
  }

  ThemeData _buildDraculaTheme() {
    // Dracula color palette
    const draculaBackground = Color(0xFF282a36);
    const draculaCurrentLine = Color(0xFF44475a);
    const draculaForeground = Color(0xFFf8f8f2);
    const draculaComment = Color(0xFF6272a4);
    const draculaCyan = Color(0xFF8be9fd);
    const draculaGreen = Color(0xFF50fa7b);
    const draculaOrange = Color(0xFFffb86c);
    const draculaPink = Color(0xFFff79c6);
    const draculaPurple = Color(0xFFbd93f9);
    const draculaRed = Color(0xFFff5555);
    const draculaYellow = Color(0xFFf1fa8c);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Primary colors
      primaryColor: draculaPurple,
      primaryColorDark: draculaPurple,
      primaryColorLight: draculaPink,

      // Background colors
      scaffoldBackgroundColor: draculaBackground,
      canvasColor: draculaBackground,

      // Card and surface colors
      cardColor: draculaCurrentLine,
      dialogBackgroundColor: draculaCurrentLine,

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: draculaCurrentLine,
        foregroundColor: draculaForeground,
        elevation: 0,
      ),

      // Text colors
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: draculaForeground),
        bodyMedium: TextStyle(color: draculaForeground),
        bodySmall: TextStyle(color: draculaComment),
        headlineLarge: TextStyle(color: draculaForeground),
        headlineMedium: TextStyle(color: draculaForeground),
        headlineSmall: TextStyle(color: draculaForeground),
        titleLarge: TextStyle(color: draculaForeground),
        titleMedium: TextStyle(color: draculaForeground),
        titleSmall: TextStyle(color: draculaForeground),
        labelLarge: TextStyle(color: draculaForeground),
        labelMedium: TextStyle(color: draculaForeground),
        labelSmall: TextStyle(color: draculaComment),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: draculaCurrentLine,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: draculaComment),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: draculaComment),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: draculaCyan),
        ),
        labelStyle: TextStyle(color: draculaComment),
        hintStyle: TextStyle(color: draculaComment.withOpacity(0.7)),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: draculaPurple,
          foregroundColor: draculaForeground,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: draculaPurple,
          foregroundColor: draculaForeground,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: draculaCyan,
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: draculaGreen,
        foregroundColor: draculaBackground,
      ),

      // List tile
      listTileTheme: ListTileThemeData(
        textColor: draculaForeground,
        tileColor: draculaCurrentLine,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: draculaCurrentLine,
        titleTextStyle: TextStyle(color: draculaForeground),
        contentTextStyle: TextStyle(color: draculaForeground),
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: draculaCurrentLine,
        modalBackgroundColor: draculaCurrentLine,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: draculaCurrentLine,
        contentTextStyle: TextStyle(color: draculaForeground),
        actionTextColor: draculaCyan,
      ),

      // Radio button
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return draculaCyan;
          }
          return draculaComment;
        }),
      ),

      // Progress indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: draculaCyan,
      ),

      // Divider
      dividerColor: draculaComment.withOpacity(0.3),
    );
  }
}
