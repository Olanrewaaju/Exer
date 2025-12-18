import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class InitialDatabase {
  static final InitialDatabase instance = InitialDatabase._init();

  static Database? _database;

  InitialDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS data');
      await _createDB(db, newVersion);
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE data(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
gifUrl TEXT,
part TEXT NOT NULL,
exerciseId TEXT,
description TEXT,
targetMuscles TEXT,
secondaryMuscles TEXT,
bodyParts TEXT,
instructions TEXT
)
''');
  }

  Future updateTab(Map<String, dynamic> rows) async {
    final db = await instance.database;
    int id = rows['id'];
    return await db.update('data', rows, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> displayTab() async {
    final db = await instance.database;
    final results = await db.query('data');

    // Parse JSON strings back to Lists
    return results.map((row) {
      final parsed = Map<String, dynamic>.from(row);

      if (parsed['targetMuscles'] != null &&
          parsed['targetMuscles'] is String) {
        parsed['targetMuscles'] = jsonDecode(parsed['targetMuscles']);
      }
      if (parsed['secondaryMuscles'] != null &&
          parsed['secondaryMuscles'] is String) {
        parsed['secondaryMuscles'] = jsonDecode(parsed['secondaryMuscles']);
      }
      if (parsed['bodyParts'] != null && parsed['bodyParts'] is String) {
        parsed['bodyParts'] = jsonDecode(parsed['bodyParts']);
      }
      if (parsed['instructions'] != null && parsed['instructions'] is String) {
        parsed['instructions'] = jsonDecode(parsed['instructions']);
      }

      return parsed;
    }).toList();
  }

  Future insertTab(Map<String, dynamic> rows) async {
    final db = await instance.database;

    // Convert Lists to JSON strings for storage
    final dataToInsert = Map<String, dynamic>.from(rows);

    if (dataToInsert['targetMuscles'] is List) {
      dataToInsert['targetMuscles'] = jsonEncode(dataToInsert['targetMuscles']);
    }
    if (dataToInsert['secondaryMuscles'] is List) {
      dataToInsert['secondaryMuscles'] = jsonEncode(
        dataToInsert['secondaryMuscles'],
      );
    }
    if (dataToInsert['bodyParts'] is List) {
      dataToInsert['bodyParts'] = jsonEncode(dataToInsert['bodyParts']);
    }
    if (dataToInsert['instructions'] is List) {
      dataToInsert['instructions'] = jsonEncode(dataToInsert['instructions']);
    }

    return await db.insert(
      'data',
      dataToInsert,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future deleteTab(int id) async {
    final db = await instance.database;
    return await db.delete('data', where: 'id =?', whereArgs: [id]);
  }
}
