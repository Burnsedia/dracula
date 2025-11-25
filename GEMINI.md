# Project: Dracula

## Project Overview

Dracula is a privacy-focused blood sugar tracking application built with Flutter. The app allows users to log their blood sugar levels, which are stored locally on the device. The project aims to provide a simple, intuitive interface using Material Design and the Dracula color theme. Key features include offline data storage, data export to CSV, and cross-platform support for mobile and desktop.

**Core Technologies:**

*   **Framework:** Flutter
*   **Language:** Dart
*   **Design:** Material Design

**Architecture:**

The application follows a simple stateful widget architecture. The main screen (`HomeScreen`) manages a list of `BloodSugarLog` objects in its state. New records can be added through the `AddRecordScreen`, and the list is updated in memory. Data persistence is not yet implemented, as the `bloodSugarService.dart` is currently empty.

## Building and Running

**1. Prerequisites:**

*   Flutter SDK: Make sure you have the Flutter SDK installed and configured.
*   Dependencies: Run `flutter pub get` in the `dracula` directory to install the required dependencies.

**2. Running the App:**

*   **Mobile:**
    *   Run `flutter run` in the `dracula` directory to launch the app on a connected device or emulator.
*   **Desktop:**
    *   To run on desktop, first enable desktop support for your Flutter installation. Then, use `flutter run -d <platform>` where `<platform>` is `linux`, `windows`, or `macos`.

**3. Building the App:**

*   **Android:**
    *   Run `flutter build apk` or `flutter build appbundle` in the `dracula` directory.
*   **iOS:**
    *   Run `flutter build ios` in the `dracula` directory.
*   **Desktop:**
    *   Run `flutter build <platform>` where `<platform>` is `linux`, `windows`, or `macos`.

## Development Conventions

*   **Code Style:** The project uses the `flutter_lints` package to enforce good coding practices. The analysis options are configured in `analysis_options.yaml`.
*   **File Structure:** The code is organized into `screens`, `models`, `components`, and `services` directories within the `lib` folder.
*   **State Management:** The app currently uses `StatefulWidget` for state management.
*   **Testing:** A basic widget test is included in `test/widget_test.dart`. To run tests, use the `flutter test` command.
