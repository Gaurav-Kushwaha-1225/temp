import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../utils/enums.dart';

class SqliteService {
  static const String tableName = 'notes';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            content TEXT, 
            category TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )''',
        );
      },
      version: 2,
    );
  }

  Future<List<Map<String, dynamic>>> fetchNotes({NoteSortBy? sortBy}) async {
    final db = await database;
    String orderBy;

    switch (sortBy) {
      case NoteSortBy.dateDesc:
        orderBy = 'updatedAt DESC';
        break;
      case NoteSortBy.dateAsc:
        orderBy = 'updatedAt ASC';
        break;
      case NoteSortBy.titleAsc:
        orderBy = 'title ASC';
        break;
      case NoteSortBy.titleDesc:
        orderBy = 'title DESC';
        break;
      case null:
        orderBy = 'updatedAt DESC';
    }

    return await db.query(tableName, orderBy: orderBy);
  }

  Future<int> insertNote(Map<String, dynamic> note) async {
    final db = await database;
    note['createdAt'] = DateTime.now().toIso8601String();
    note['updatedAt'] = DateTime.now().toIso8601String();
    return db.insert(tableName, note);
  }

  Future<int> updateNote(Map<String, dynamic> note) async {
    final db = await database;
    note['updatedAt'] = DateTime.now().toIso8601String();
    return db.update(tableName, note, where: 'id = ?', whereArgs: [note['id']]);
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getNote(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<int> restoreNote(Map<String, dynamic> note) async {
    final db = await database;
    return db.insert(tableName, note);
  }
}
