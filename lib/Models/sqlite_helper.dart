import 'dart:core';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task.dart';

class SqliteHelper {
  static const dbname = 'tasksdb.db';
  static const dbVer = 1;
  static const tableName = 'tasks';

  static Database? database;

  static Future<void> init() async {
    if (database != null) return;
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, dbname);
    database = await openDatabase(path,
        version: dbVer, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static void _onCreate(Database db, int ver) async {
    String query =
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, done INTEGER, title STRING, date STRING, time STRING)';
    await db.execute(query);
  }

  static void _onUpgrade(Database db, int oldVer, int newVer) async {}

  static Future<int> insert(String table, Task task) async {
    return await database!.insert(table, task.toJson());
  }

  static Future<int> update(String table, Task task) async {
    return await database!
        .update(table, task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> delete(String table, Task task) async {
    return await database!.delete(table, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return database!.query(table);
  }

  static Future<List<Map<String, dynamic>>> doneQuery(String table) async {
    return database!.query(table, where: 'done = ?', whereArgs: [1]);
  }

  static Future<List<Map<String, dynamic>>> undoneQuery(String table) async {
    return database!.query(table, where: 'done = ?', whereArgs: [0]);
  }
}
