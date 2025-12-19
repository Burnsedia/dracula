# 🧛‍♂️ Dracula: Privacy-First Blood Sugar & Nutrition Tracker

A comprehensive, offline-first health tracking app built with Flutter for managing diabetes and nutrition. Features zero telemetry, local SQLite storage, and advanced blood sugar-meal correlations.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Sponsor](https://img.shields.io/badge/Sponsor-GitHub%20Sponsors-blue?logo=github)](https://github.com/sponsors/Burnsedia)

## 📱 Features

### 🩸 Blood Sugar Tracking
- **Manual Logging**: Add, edit, delete blood sugar readings with before/after meal flags
- **Custom Categories**: Flexible categorization (fasting, post-meal, exercise, etc.)
- **Unit Conversion**: Automatic mg/dL ↔ mmol/L conversion
- **Time Zone Aware**: Displays readings in user's local timezone

### 🍎 Comprehensive Meal Tracking
- **Macro Nutrients**: Track carbs, protein, fat, and calories
- **Micro Nutrients**: Monitor fiber, sugar, sodium, vitamin C, calcium, iron
- **Premade Meals**: Quick-select common foods (breakfast, lunch, snacks, etc.)
- **Custom Entries**: Full nutrition data input for detailed logging

### 📊 Analytics & Insights
- **Interactive Charts**: Beautiful line charts showing blood sugar trends over time
- **Statistical Analysis**: Average readings, high/low alerts, correlation insights
- **Blood Sugar-Meal Correlation**: Link meals to blood sugar readings for better insights
- **Export Data**: CSV/TXT export for external analysis

### 🔒 Security & Privacy
- **Biometric Lock**: PIN and fingerprint/face authentication
- **Zero Telemetry**: No data collection or sharing
- **Local Storage**: All data stays on your device
- **Offline-First**: Works without internet connection

### 🔔 Smart Features
- **Daily Reminders**: Customizable notifications for blood sugar checks
- **Data Import**: CSV import with field mapping
- **Multi-Language**: Internationalization support (English ready)

## 📸 Screenshots

*[Screenshots would go here - add images from app testing]*

## 🚀 Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Burnsedia/dracula.git
   cd dracula
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Building for Release

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ipa --release
```

## 📖 Usage

### First Time Setup
1. Launch the app
2. Complete onboarding
3. Set up biometric lock (optional)
4. Configure units and reminders

### Logging Blood Sugar
1. Tap the "+" button on the home screen
2. Enter blood sugar value
3. Select before/after meal
4. Choose category and meal (if applicable)
5. Save the reading

### Tracking Meals
1. Navigate to Meals from the app bar
2. Add new meals with nutrient data
3. Use premade options for quick logging
4. View meal history and correlations

### Viewing Analytics
1. Go to Analytics/Charts screens
2. View trend charts and statistics
3. Export data for external analysis

## 🏛️ Architecture

### Project Structure
```
lib/
├── models/          # Data models (BloodSugarLog, Meal, Category)
├── screens/         # UI screens and widgets
├── services/        # Business logic and database operations
├── components/      # Reusable UI components
├── l10n/           # Localization files
└── main.dart       # App entry point
```

### Database Schema
- **blood_sugar_logs**: Blood sugar readings with metadata
- **meals**: Nutrition data and meal information
- **exercise_logs**: Physical activity tracking
- **categories**: Custom categorization system

### State Management
- Stateful widgets for local state
- Provider pattern for shared state
- SQLite for persistent data storage

## 🧪 Testing

Run the full test suite:
```bash
flutter test
```

### Test Coverage
- **Unit Tests**: Model serialization and business logic
- **Widget Tests**: UI component interactions
- **Integration Tests**: End-to-end user workflows

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📋 Development Commands

```bash
# Run linting
flutter analyze

# Format code
flutter format .

# Run tests
flutter test

# Build for all platforms
flutter build apk && flutter build ios
```

## 📚 Resources

- [Development Log](DEVLOG.md) - Complete development journey and technical details
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)

## 🔒 Privacy & Security

Dracula is designed with privacy as the highest priority:
- **No Data Collection**: Zero telemetry or analytics
- **Local Storage Only**: All data remains on device
- **Open Source**: Transparent code for security audits
- **Biometric Protection**: Optional device-level security

## 📄 License

This project is licensed under the GNU Affero General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter community for amazing documentation and tools
- Material Design for beautiful UI components
- Open source libraries used in this project

---

**Disclaimer**: Dracula is a personal health tracking tool and not medical advice. Please consult healthcare professionals for diabetes management and nutrition guidance.

Made with ❤️ using Flutter

<!-- Test commit for CI trigger -->
