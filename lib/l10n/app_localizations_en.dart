// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dracula';

  @override
  String get homeTitle => 'Blood Sugar Tracker';

  @override
  String get addEntry => 'Add Entry';

  @override
  String get settings => 'Settings';

  @override
  String get charts => 'View Charts';

  @override
  String get analytics => 'View Analytics';

  @override
  String get exerciseTracker => 'Exercise Tracker';
}
