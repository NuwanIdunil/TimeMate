import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    print("sucsess");
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'task_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        imagePath TEXT NOT NULL
      )
    ''');
  }

  Future<int> registerUser(
      String email, String password, String name, String imagePath) async {
    Database db = await instance.database;
    print(imagePath);
    return await db.insert('users', {
      'email': email,
      'password': password,
      'name': name,
      'imagePath': imagePath,
    });
  }

  Future<bool> loginUser(String email, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await instance.database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception('User not found');
    }
  }

  Future<int> updateUser(String email, String name, String imagePath) async {
    Database db = await instance.database;

    return await db.update(
      'users',
      {
        'name': name,
        'imagePath': imagePath,
      },
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}
