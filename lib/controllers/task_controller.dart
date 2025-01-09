import 'package:hope_home/models/Event/task.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';

class TaskController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<List<Map<String, dynamic>>> fetchTasksWithEventNames() async {
    return await _dbService.fetchAllTasksWithEventNames();
  }
}
