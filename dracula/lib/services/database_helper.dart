import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dracula/models/bloodsugar.dart';

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
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE blood_sugar_logs ( 
  id $idType, 
  bloodSugar $doubleType,
  isBeforeMeal $boolType,
  createdAt $textType
  )
''');
  }

  Future<BloodSugarLog> create(BloodSugarLog log) async {
    final db = await instance.database;
    final id = await db.insert('blood_sugar_logs', log.toJson());
    return log.copyWith(id: id);
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
}
