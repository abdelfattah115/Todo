import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 10;
  static const String tableName = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      debugPrint('DB not null');
      return;
    } else {
      try {

        String path = await getDatabasesPath()+'tasks.db';
        _db = await openDatabase(path, version: _version,
            onCreate: (Database db, int version) async {
              // When creating the db, create the table
              await db.execute(
                  'CREATE TABLE $tableName('
                      'id INTEGER PRIMARY KEY, '
                      'title STRING, note TEXT, date STRING, '
                      'startTime STRING, endTime STRING, '
                      'remind INTEGER, repeat STRING, '
                      'color INTEGER, '
                      'isCompleted INTEGER)'
              );
              print('DataBase Created');
            });
      } catch (error) {
        print('an error occurred $error');
      }
    }
  }

   Future<int> insert(Task? task) async {
    print('Insert function called');
    try {
      return await _db!.insert(tableName, task!.toJson(),);
    } catch (error) {
      print('We are here');
      return 90000;
    }
  }

   Future<int> delete(Task task) async {
    print('Delete function called');
    return await _db!.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
  }

   Future<int> deleteAll() async{
    print('Delete function called');
    return  await _db!.delete(tableName);
  }

   Future<List<Map<String, dynamic>>> query() async {
    print('Query function called');
    return await _db!.query(tableName);
  }

   Future<int> update(int id) async {
    print('Update function called');
    return await _db!.rawUpdate('''
       UPDATE tasks
       SET isCompleted = ?
       WHERE id = ? 
        ''', [1, id]);
  }
}
