import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController{

  final RxList<Task> taskList = <Task>[].obs;
  DBHelper  dbHelper = DBHelper();

  Future<int> addTasks({required Task task}) async{
    return  await dbHelper.insert(task);
  }

  //get data(tasks) from data base
  Future<void> getTasks() async{
    final List<Map<String, Object?>>? tasks = await dbHelper.query();
    taskList.assignAll(tasks!.map((data) => Task.fromJson(data)).toList());
  }

  void markTaskComplete(int id) async{
    await dbHelper.update(id);
    getTasks();
  }

  void deleteTask(Task task) async{
    await dbHelper.delete(task);
    getTasks();
  }

  void deleteAllTask() async{
    await dbHelper.deleteAll();
    getTasks();
  }
}