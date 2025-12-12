# AGENTS.md - Blood Sugar Tracking App

## Build/Test Commands
- **Build app**: `flutter build apk` (Android) or `flutter build ios` (iOS)
- **Run app**: `flutter run`
- **Run all tests**: `flutter test`
- **Run single test**: `flutter test test/model/bloodsugar_test.dart` (replace with specific test file)
- **Lint code**: `flutter analyze`
- **Format code**: `flutter format .`

## Code Style Guidelines

### Imports
- Use relative imports with `../` for local files
- Group imports: Flutter SDK first, then local imports
- Example: `import 'package:flutter/material.dart';` then `import "../models/bloodsugar.dart";`

### Naming Conventions
- **Classes**: PascalCase (e.g., `BloodSugarLog`, `HomeScreen`)
- **Variables/Methods**: camelCase (e.g., `bloodSugar`, `isBeforeMeal`)
- **Files**: PascalCase for screens/widgets, snake_case for services/models

### Formatting & Types
- Use double quotes for strings
- Use `const` for compile-time constants
- Use `final` for immutable variables
- Explicit types preferred over `var` for clarity
- Factory constructors for JSON serialization/deserialization

### Error Handling
- Use try-catch blocks for async operations
- Validate user input before processing
- Show user-friendly error messages via SnackBar/AlertDialog

### Widget Patterns
- Use `StatefulWidget` for dynamic UI, `StatelessWidget` for static
- Prefer `const` constructors when possible
- Use meaningful keys for widget testing

### Testing
- Unit tests in `test/model/` for models
- Widget tests in `test/` root for UI components
- Use `group()` to organize related tests
- Test both success and error scenarios</content>
<parameter name="filePath">/home/cypher/dev/apps/dracula/AGENTS.md