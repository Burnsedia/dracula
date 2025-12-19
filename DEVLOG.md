# Building Dracula: A Privacy-First Blood Sugar Tracking App

**Posted on [Date] by [Your Name]**

Hey fellow developers and health enthusiasts! Today, I'm excited to share the complete development journey of **Dracula**, my privacy-first blood sugar and health tracking app built with Flutter. This isn't just a project showcase—it's a deep dive into building a production-ready health app from scratch, complete with MVPs, technical challenges, and lessons learned. Let's dive in!

## What is Dracula?

Dracula is a cross-platform mobile app designed for people managing diabetes or monitoring blood sugar levels. What sets it apart? **Zero telemetry, local-only storage, and comprehensive nutrition tracking**. Built with Flutter and SQLite, it runs on both Android and iOS with a sleek Dracula-inspired dark theme.

The app started as a simple logging tool but evolved into a full-featured health companion. Here's how it happened.

## MVP 1: Core Offline Functionality

Every great app starts simple. For Dracula, MVP 1 focused on the essentials:

- **Blood Sugar Logging**: Users can add, edit, and delete readings with before/after meal flags
- **Custom Categories**: Flexible categorization for different types of readings (e.g., fasting, post-meal)
- **Smart Settings**: Unit conversion (mg/dL vs mmol/L), timezone display, and CSV export
- **Secure Storage**: SQLite database with offline-first design
- **Privacy by Design**: No cloud storage, no data sharing—everything stays on the device

The tech stack was straightforward: Flutter with Provider for state management (later evolved), and sqflite for database operations. I implemented a clean architecture with models, services, and screens.

```dart
class BloodSugarLog {
  final int? id;
  final double bloodSugar;
  final bool isBeforeMeal;
  final DateTime createdAt;
  // ... more fields
}
```

## MVP 2: Analytics & User Experience

Once the core logging worked, it was time to make it useful. MVP 2 brought data visualization and usability improvements:

- **Interactive Charts**: Beautiful line charts using fl_chart showing trends over days/weeks
- **Statistical Insights**: Average readings, high/low alerts, and trend analysis
- **Daily Reminders**: Customizable notifications with flutter_local_notifications
- **Security Features**: Biometric app lock using local_auth
- **Enhanced UI**: Material 3 components, smooth animations, and responsive design

This phase taught me a lot about Flutter's animation system and notification scheduling. The charts were particularly challenging—getting the data aggregation right while maintaining performance.

## MVP 3 & The Nutrition Revolution

The latest evolution added comprehensive meal tracking, turning Dracula from a blood sugar logger into a full nutrition-blood sugar correlation tool:

### Meal Tracking System
- **Macro Nutrients**: Carbs, protein, fat, and calories
- **Micro Nutrients**: Fiber, sugar, sodium, vitamins, and minerals
- **Premade Meals**: Quick-select common foods for convenience
- **Custom Entries**: Full nutrition data input for detailed logging

### Blood Sugar-Meal Correlation
The killer feature: When logging blood sugar "before meal," users can select the meal they're about to eat. This creates powerful correlations for better health insights.

```dart
// Database schema evolution
if (oldVersion < 4) {
  // Create meals table with all nutrient fields
}
if (oldVersion < 5) {
  // Add mealId to blood sugar logs
}
```

## Technical Deep Dive: Challenges & Solutions

### Database Evolution
Managing schema changes across app versions was tricky. I implemented proper migration logic:

```dart
Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('DROP TABLE IF EXISTS blood_sugar_logs');
    await _createDB(db, newVersion);
  }
  // ... more migrations
}
```

### Testing Strategy
Following TDD principles, I built comprehensive tests:

- **Unit Tests**: Model serialization, business logic
- **Widget Tests**: UI interactions, form validation  
- **Integration Tests**: End-to-end workflows

The meal-blood sugar correlation required careful testing of the linked data relationships.

### Cross-Platform Headaches
Supporting Android and iOS meant handling platform-specific quirks:
- File picker implementations vary by platform
- Notification permissions differ
- Biometric authentication APIs have different capabilities

## Lessons Learned

1. **Start Simple, Scale Smart**: MVP 1 proved the core concept; each iteration added value without overcomplicating.

2. **Privacy Matters**: Users trust health apps with sensitive data. Building privacy-first from day one was crucial.

3. **Testing Saves Time**: Early test failures caught bugs before they became user issues.

4. **Database Design is Forever**: Plan your schema carefully—migrations are painful!

5. **User Experience is Everything**: The app's success depends on how intuitive and helpful it feels.

## Recent Updates & CI/CD Implementation

As Dracula evolves, I've focused on production readiness and developer experience:

### CI/CD Pipeline Setup
- **GitHub Actions**: Full automation for building, testing, and deploying across platforms
- **Multi-Platform Builds**: Android APK/AAB, iOS IPA, Linux desktop, macOS app, Windows executable
- **Automated Testing**: Unit, widget, and integration tests with proper timeouts and error handling
- **Deployment Ready**: Fastlane integration for Google Play, F-Droid, and App Store releases

### Database Enhancements
- **Schema Evolution**: Robust migration system for adding new features like meal tracking
- **Cross-Platform DB**: Sqflite with FFI for Linux/desktop compatibility
- **Error Handling**: Comprehensive logging and recovery for database operations

### Testing & Quality Assurance
- **Integration Tests**: End-to-end workflows with extended timeouts for async operations
- **Debug Logging**: Detailed save operation tracking for troubleshooting
- **Performance**: Optimized for smooth operation on emulators and devices

### Development Workflow Improvements
- **Privacy Audit**: Runtime checks ensure no telemetry leaks
- **Localization**: English support with extensible framework for multiple languages
- **Code Quality**: Linting, formatting, and modular architecture

## What's Next?

Dracula is feature-complete for core use cases, but the roadmap includes:
- Health data sync with wearables
- Advanced AI-powered insights
- Multi-language support expansion
- Performance monitoring and optimization
- Cloud backup options (optional, privacy-controlled)

## Conclusion

Building Dracula was an incredible journey from concept to production-ready app. It taught me Flutter best practices, health app development nuances, and the importance of user privacy.

The app is now available on [GitHub link], fully open-source. If you're managing blood sugar or building health apps, I'd love to hear your thoughts!

Have you built any health-related apps? What challenges did you face? Drop a comment below!

---

*Disclaimer: Dracula is a personal project and not medical advice. Consult healthcare professionals for diabetes management.*

*#Flutter #MobileDevelopment #HealthTech #PrivacyFirst #OpenSource*