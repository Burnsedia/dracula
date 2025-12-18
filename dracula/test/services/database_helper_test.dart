import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dracula/models/bloodsugar.dart';
import 'package:dracula/models/meal.dart';
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
      // Clear tables for clean tests
      await db.delete('meals');
      await db.delete('blood_sugar_logs');
      await db.delete('exercise_logs');
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

    group('Meal CRUD operations', () {
      test('createMeal inserts a Meal and returns it with id', () async {
        final meal = Meal(
          name: 'Test Meal',
          dateTime: DateTime.now(),
          carbs: 50.0,
          protein: 25.0,
          fat: 15.0,
          calories: 400.0,
        );

        final created = await dbHelper.createMeal(meal);

        expect(created.id, isNotNull);
        expect(created.name, meal.name);
        expect(created.carbs, meal.carbs);
        expect(created.protein, meal.protein);
        expect(created.fat, meal.fat);
        expect(created.calories, meal.calories);
      });

      test('readMeal retrieves a Meal by id', () async {
        final meal = Meal(
          name: 'Test Meal',
          dateTime: DateTime.now(),
          carbs: 50.0,
        );

        final created = await dbHelper.createMeal(meal);
        final read = await dbHelper.readMeal(created.id!);

        expect(read.id, created.id);
        expect(read.name, meal.name);
        expect(read.carbs, meal.carbs);
      });

      test('readMeal throws exception for non-existent id', () async {
        expect(() => dbHelper.readMeal(999), throwsException);
      });

      test('readAllMeals returns all Meals ordered by dateTime DESC', () async {
        final now = DateTime.now();
        final meal1 = Meal(
          name: 'Breakfast',
          dateTime: now.subtract(Duration(hours: 1)),
          calories: 300.0,
        );
        final meal2 = Meal(
          name: 'Lunch',
          dateTime: now,
          calories: 500.0,
        );

        await dbHelper.createMeal(meal1);
        await dbHelper.createMeal(meal2);

        final all = await dbHelper.readAllMeals();

        expect(all.length, 2);
        expect(all[0].name, 'Lunch'); // Most recent first
        expect(all[1].name, 'Breakfast');
      });

      test('updateMeal modifies an existing Meal', () async {
        final meal = Meal(
          name: 'Original Meal',
          dateTime: DateTime.now(),
          carbs: 50.0,
        );

        final created = await dbHelper.createMeal(meal);
        final updatedMeal =
            created.copyWith(name: 'Updated Meal', protein: 25.0);

        final rowsAffected = await dbHelper.updateMeal(updatedMeal);
        expect(rowsAffected, 1);

        final read = await dbHelper.readMeal(created.id!);
        expect(read.name, 'Updated Meal');
        expect(read.protein, 25.0);
      });

      test('deleteMeal removes a Meal by id', () async {
        final meal = Meal(
          name: 'Test Meal',
          dateTime: DateTime.now(),
        );

        final created = await dbHelper.createMeal(meal);
        final rowsAffected = await dbHelper.deleteMeal(created.id!);
        expect(rowsAffected, 1);

        expect(() => dbHelper.readMeal(created.id!), throwsException);
      });
    });
  });
}
