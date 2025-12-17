import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/models/bloodsugar.dart';
import 'package:dracula/services/database_helper.dart';

void main() {
  // Initialize sqflite for testing
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseHelper', () {
    late DatabaseHelper dbHelper;
    late Database db;

    setUp(() async {
      dbHelper = DatabaseHelper.instance;
      db = await dbHelper.database;
    });

    tearDown(() async {
      // await dbHelper.close(); // Commented out for testing
    });

    test('create inserts a BloodSugarLog and returns it with id', () async {
      final log = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );

      final created = await dbHelper.create(log);

      expect(created.id, isNotNull);
      expect(created.bloodSugar, log.bloodSugar);
      expect(created.isBeforeMeal, log.isBeforeMeal);
    });

    test('read retrieves a BloodSugarLog by id', () async {
      final log = BloodSugarLog(
        bloodSugar: 130.0,
        isBeforeMeal: false,
        createdAt: DateTime.now(),
      );

      final created = await dbHelper.create(log);
      final read = await dbHelper.read(created.id!);

      expect(read.id, created.id);
      expect(read.bloodSugar, log.bloodSugar);
      expect(read.isBeforeMeal, log.isBeforeMeal);
    });

    test('read throws exception for non-existent id', () async {
      expect(() => dbHelper.read(999), throwsException);
    });

    test('readAll returns all BloodSugarLogs ordered by createdAt DESC',
        () async {
      final now = DateTime.now();
      final log1 = BloodSugarLog(
          bloodSugar: 100.0,
          isBeforeMeal: true,
          createdAt: now.subtract(Duration(hours: 1)));
      final log2 =
          BloodSugarLog(bloodSugar: 110.0, isBeforeMeal: false, createdAt: now);

      await dbHelper.create(log1);
      await dbHelper.create(log2);

      final all = await dbHelper.readAll();

      expect(all.length, 2);
      expect(all[0].bloodSugar, 110.0); // Most recent first
      expect(all[1].bloodSugar, 100.0);
    });

    test('update modifies an existing BloodSugarLog', () async {
      final log = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );

      final created = await dbHelper.create(log);
      final updatedLog =
          created.copyWith(bloodSugar: 125.0, isBeforeMeal: false);

      final rowsAffected = await dbHelper.update(updatedLog);
      expect(rowsAffected, 1);

      final read = await dbHelper.read(created.id!);
      expect(read.bloodSugar, 125.0);
      expect(read.isBeforeMeal, false);
    });

    test('delete removes a BloodSugarLog by id', () async {
      final log = BloodSugarLog(
        bloodSugar: 120.0,
        isBeforeMeal: true,
        createdAt: DateTime.now(),
      );

      final created = await dbHelper.create(log);
      final rowsAffected = await dbHelper.delete(created.id!);
      expect(rowsAffected, 1);

      expect(() => dbHelper.read(created.id!), throwsException);
    });
  });
}
