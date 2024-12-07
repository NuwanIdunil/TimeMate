import 'package:flutter/foundation.dart';
import 'database_helper_for_task.dart';
import 'task.dart';

class TaskViewModel extends ChangeNotifier {
  final DatabaseHelperForTask _dbHelper = DatabaseHelperForTask.instance;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks(String email) async {
    _tasks = await _dbHelper.getTasks(email);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _dbHelper.addTask(task);
    await loadTasks(task.email);
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    await loadTasks(task.email);
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
  }
}
