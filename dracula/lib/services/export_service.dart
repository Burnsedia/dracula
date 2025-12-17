import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../models/bloodsugar.dart';
import '../models/exercise.dart';
import '../services/database_helper.dart';
import '../services/settings_service.dart';

class ExportService {
  static Future<void> exportBloodSugarToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await DatabaseHelper.instance.readAll();
    final filteredRecords = _filterRecords(records, startDate, endDate);
    final unit = await SettingsService().getBloodSugarUnit();

    final csvData = [
      ['Date', 'Time', 'Blood Sugar', 'Unit', 'Before Meal'],
      ...filteredRecords.map((record) {
        final displayValue =
            SettingsService().convertToDisplayUnit(record.bloodSugar, unit);
        final unitString = SettingsService().getUnitDisplayString(unit);
        return [
          record.createdAt.toString().split(' ')[0], // Date
          record.createdAt.toString().split(' ')[1], // Time
          displayValue.toStringAsFixed(1),
          unitString,
          record.isBeforeMeal ? 'Yes' : 'No',
        ];
      }),
    ];

    final csvString = const ListToCsvConverter().convert(csvData);
    await _saveAndShareFile(csvString, 'blood_sugar_export.csv');
  }

  static Future<void> exportBloodSugarToTXT({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await DatabaseHelper.instance.readAll();
    final filteredRecords = _filterRecords(records, startDate, endDate);
    final unit = await SettingsService().getBloodSugarUnit();

    final buffer = StringBuffer();
    buffer.writeln('Blood Sugar Export');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('');

    for (final record in filteredRecords) {
      final displayValue =
          SettingsService().convertToDisplayUnit(record.bloodSugar, unit);
      final unitString = SettingsService().getUnitDisplayString(unit);
      buffer.writeln(
          '${record.createdAt}: ${displayValue.toStringAsFixed(1)} $unitString (${record.isBeforeMeal ? "Before" : "After"} meal)');
    }

    await _saveAndShareFile(buffer.toString(), 'blood_sugar_export.txt');
  }

  static Future<void> exportExercisesToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final records = await DatabaseHelper.instance.readAllExercises();
    final filteredRecords = _filterExerciseRecords(records, startDate, endDate);

    final csvData = [
      [
        'Date',
        'Time',
        'Exercise Type',
        'Duration (min)',
        'Before Blood Sugar',
        'After Blood Sugar'
      ],
      ...filteredRecords.map((record) => [
            record.createdAt.toString().split(' ')[0],
            record.createdAt.toString().split(' ')[1],
            record.exerciseType,
            record.durationMinutes.toString(),
            record.beforeBloodSugar?.toStringAsFixed(1) ?? '',
            record.afterBloodSugar?.toStringAsFixed(1) ?? '',
          ]),
    ];

    final csvString = const ListToCsvConverter().convert(csvData);
    await _saveAndShareFile(csvString, 'exercise_export.csv');
  }

  static Future<void> exportDatabase() async {
    final dbPath = await DatabaseHelper.instance.database.then((db) => db.path);
    final dbFile = File(dbPath);
    final downloadsDir = await getDownloadsDirectory();
    final exportPath = '${downloadsDir?.path ?? '/tmp'}/dracula_backup.db';
    await dbFile.copy(exportPath);

    await Share.shareXFiles(
      [XFile(exportPath)],
      text: 'Dracula database backup',
    );
  }

  static List<BloodSugarLog> _filterRecords(
      List<BloodSugarLog> records, DateTime? start, DateTime? end) {
    if (start == null && end == null) return records;
    return records.where((record) {
      final date = record.createdAt;
      if (start != null && date.isBefore(start)) return false;
      if (end != null && date.isAfter(end)) return false;
      return true;
    }).toList();
  }

  static List<ExerciseLog> _filterExerciseRecords(
      List<ExerciseLog> records, DateTime? start, DateTime? end) {
    if (start == null && end == null) return records;
    return records.where((record) {
      final date = record.createdAt;
      if (start != null && date.isBefore(start)) return false;
      if (end != null && date.isAfter(end)) return false;
      return true;
    }).toList();
  }

  static Future<void> _saveAndShareFile(String content, String filename) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Exported data from Dracula',
    );
  }
}
