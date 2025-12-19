import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dracula/models/bloodsugar.dart';
import 'package:dracula/models/exercise.dart';
import 'package:dracula/models/category.dart';
import 'package:dracula/models/meal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dracula.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dracula_v4.db');

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const nullableDoubleType = 'REAL';

    await db.execute('''
CREATE TABLE blood_sugar_logs (
  id $idType,
  bloodSugar $doubleType,
  isBeforeMeal $intType,
  categoryId INTEGER,
  mealId INTEGER,
  createdAt $textType
  )
''');

    await db.execute('''
CREATE TABLE exercise_logs (
  id $idType,
  exerciseType $textType,
  durationMinutes $intType,
  categoryId INTEGER,
  beforeBloodSugar $nullableDoubleType,
  afterBloodSugar $nullableDoubleType,
  createdAt $textType
  )
''');

    await db.execute('''
CREATE TABLE categories (
  id $idType,
  name $textType,
  unit TEXT,
  type $textType
  )
''');

    await db.execute('''
CREATE TABLE meals (
  id $idType,
  name $textType,
  dateTime $textType,
  categoryId INTEGER,
  carbs $nullableDoubleType,
  protein $nullableDoubleType,
  fat $nullableDoubleType,
  calories $nullableDoubleType,
  fiber $nullableDoubleType,
  sugar $nullableDoubleType,
  sodium $nullableDoubleType,
  vitaminC $nullableDoubleType,
  calcium $nullableDoubleType,
  iron $nullableDoubleType,
  bloodSugarBefore $nullableDoubleType,
  bloodSugarAfter $nullableDoubleType
  )
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS blood_sugar_logs');
      await _createDB(db, newVersion);
    }
    if (oldVersion < 3) {
      // Add categoryId column to blood_sugar_logs
      await db.execute(
        'ALTER TABLE blood_sugar_logs ADD COLUMN categoryId INTEGER',
      );
    }
    if (oldVersion < 4) {
      // Create meals table
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT NOT NULL';
      const nullableDoubleType = 'REAL';
      await db.execute('''
CREATE TABLE meals (
  id $idType,
  name $textType,
  dateTime $textType,
  carbs $nullableDoubleType,
  protein $nullableDoubleType,
  fat $nullableDoubleType,
  calories $nullableDoubleType,
  fiber $nullableDoubleType,
  sugar $nullableDoubleType,
  sodium $nullableDoubleType,
  vitaminC $nullableDoubleType,
  calcium $nullableDoubleType,
  iron $nullableDoubleType,
  bloodSugarBefore $nullableDoubleType,
  bloodSugarAfter $nullableDoubleType
   )
''');
    }
    if (oldVersion < 5) {
      // Add mealId column to blood_sugar_logs
      await db.execute(
        'ALTER TABLE blood_sugar_logs ADD COLUMN mealId INTEGER',
      );
    }
    if (oldVersion < 6) {
      // Add categoryId to meals and exercise_logs tables
      await db.execute('ALTER TABLE meals ADD COLUMN categoryId INTEGER');
      await db.execute(
        'ALTER TABLE exercise_logs ADD COLUMN categoryId INTEGER',
      );
    }
  }

  Future<BloodSugarLog> create(BloodSugarLog log) async {
    final db = await instance.database;
    try {
      final id = await db.insert('blood_sugar_logs', log.toJson());
      return log.copyWith(id: id);
    } catch (e) {
      print('Database error in create BloodSugarLog: $e');
      rethrow;
    }
  }

  Future<BloodSugarLog> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'blood_sugar_logs',
      columns: ['id', 'bloodSugar', 'isBeforeMeal', 'createdAt'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BloodSugarLog.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<BloodSugarLog>> readAll() async {
    final db = await instance.database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('blood_sugar_logs', orderBy: orderBy);
    return result.map((json) => BloodSugarLog.fromJson(json)).toList();
  }

  Future<int> update(BloodSugarLog log) async {
    final db = await instance.database;
    return db.update(
      'blood_sugar_logs',
      log.toJson(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'blood_sugar_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Exercise methods
  Future<ExerciseLog> createExercise(ExerciseLog log) async {
    final db = await instance.database;
    final id = await db.insert('exercise_logs', log.toJson());
    return log.copyWith(id: id);
  }

  Future<ExerciseLog> readExercise(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'exercise_logs',
      columns: [
        'id',
        'exerciseType',
        'durationMinutes',
        'beforeBloodSugar',
        'afterBloodSugar',
        'createdAt',
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ExerciseLog.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ExerciseLog>> readAllExercises() async {
    final db = await instance.database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('exercise_logs', orderBy: orderBy);
    return result.map((json) => ExerciseLog.fromJson(json)).toList();
  }

  Future<int> updateExercise(ExerciseLog log) async {
    final db = await instance.database;
    return db.update(
      'exercise_logs',
      log.toJson(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await instance.database;
    return await db.delete('exercise_logs', where: 'id = ?', whereArgs: [id]);
  }

  // Category methods
  Future<Category> createCategory(Category category) async {
    final db = await instance.database;
    final id = await db.insert('categories', category.toJson());
    return category.copyWith(id: id);
  }

  Future<Category> readCategory(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'categories',
      columns: ['id', 'name', 'unit', 'type'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Category>> readAllCategories() async {
    final db = await instance.database;
    const orderBy = 'name ASC';
    final result = await db.query('categories', orderBy: orderBy);
    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future<int> updateCategory(Category category) async {
    final db = await instance.database;
    return db.update(
      'categories',
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await instance.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // Meal CRUD operations
  Future<Meal> createMeal(Meal meal) async {
    final db = await instance.database;
    final id = await db.insert('meals', meal.toJson());
    return meal.copyWith(id: id);
  }

  Future<Meal> readMeal(int id) async {
    final db = await instance.database;
    final maps = await db.query('meals', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Meal.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Meal>> readAllMeals() async {
    final db = await instance.database;
    const orderBy = 'dateTime DESC';
    final result = await db.query('meals', orderBy: orderBy);
    return result.map((json) => Meal.fromJson(json)).toList();
  }

  Future<int> updateMeal(Meal meal) async {
    final db = await instance.database;
    return db.update(
      'meals',
      meal.toJson(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<int> deleteMeal(int id) async {
    final db = await instance.database;
    return await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }
}
