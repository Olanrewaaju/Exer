import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE firstData(
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
imagePic TEXT NOT NULL
part TEXT NOT NULL
)
''');
  }

  Future updateTab(Map<String, dynamic> rows) async {
    final db = await instance.database;
    int id = rows['id'];
    return await db.update('data', rows, where: 'id = ?', whereArgs: [id]);
  }

  Future insertTab(Map<String, dynamic> rows) async {
    final db = await instance.database;
    return await db.insert('data', rows);
  }

  Future deleteTab(int id) async {
    final db = await instance.database;
    return await db.delete('data', where: 'id =?', whereArgs: [id]);
  }
}
