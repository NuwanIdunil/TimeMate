import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task.dart';

class DatabaseHelperForTask {
  static final DatabaseHelperForTask instance = DatabaseHelperForTask._init();
  static Database? _database;

  DatabaseHelperForTask._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL,
        email TEXT NOT NULL, 
        FOREIGN KEY (email) REFERENCES users(email)
      )
    ''');
  }

  Future<int> addTask(Task task) async {
    final db = await instance.database;
    return db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'tasks',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query('tasks');
  }
}
