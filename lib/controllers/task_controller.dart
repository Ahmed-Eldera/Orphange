import 'package:hope_home/models/Event/task.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';

import '../models/auth/FireAuth.dart';

class TaskController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  Future<List<Map<String, dynamic>>> fetchTasksWithEventNames() async {
    return await _dbService.fetchAllTasksWithEventNames();
  }
  Future<void> saveTask(Task task) async {
    try {
      await task.saveTask(task); // Call the model's method
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }
  Future<List<Task>> fetchAllTasks() async {
    return await _dbService.fetchAllTasks();
  }
  Future<List<Task>> fetchTasksParticipatedForLoggedInUser() async {
    final email = await _authService.getLoggedInUserEmail();
    if (email == null) {
      throw Exception("User not logged in");
    }
    return await _dbService.fetchTasksParticipated(email);
  }


}
