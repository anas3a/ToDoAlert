import 'package:sqflite/sqflite.dart';
import 'task.dart';
import 'sqlite_helper.dart';

class DataProvider {
  Future<List<Task>> getTasks() async {
    await SqliteHelper.init();
    List<Map<String, dynamic>> tasks = await SqliteHelper.query(Task.tableName);
    return tasks.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getDoneTasks() async {
    await SqliteHelper.init();
    List<Map<String, dynamic>> tasks =
        await SqliteHelper.doneQuery(Task.tableName);
    return tasks.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getUndoneTasks() async {
    await SqliteHelper.init();
    List<Map<String, dynamic>> tasks =
        await SqliteHelper.undoneQuery(Task.tableName);
    return tasks.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> addTask(Task task) async {
    await SqliteHelper.init();
    int temp = await SqliteHelper.insert(Task.tableName, task);
    return temp;
  }

  Future<bool> updateTask(Task task) async {
    await SqliteHelper.init();
    int temp = await SqliteHelper.update(Task.tableName, task);
    return temp >= 1 ? true : false;
  }

  Future<bool> deleteTask(Task task) async {
    await SqliteHelper.init();
    int temp = await SqliteHelper.delete(Task.tableName, task);
    return temp >= 1 ? true : false;
  }

  Future<int> calculateDone() async {
    await SqliteHelper.init();
    var resultDone = Sqflite.firstIntValue(await SqliteHelper.database!
        .rawQuery('SELECT COUNT(*) FROM tasks WHERE done=1'));
    return resultDone!;
  }

  Future<int> calculateAll() async {
    await SqliteHelper.init();
    var resultAll = Sqflite.firstIntValue(
        await SqliteHelper.database!.rawQuery('SELECT COUNT(*) FROM tasks'));
    return resultAll!;
  }
}
