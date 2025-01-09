import 'package:flutter/material.dart';
import 'package:hope_home/models/Event/task.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';

import '../../controllers/task_controller.dart';

class AdminTaskManagementPage extends StatefulWidget {
  const AdminTaskManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminTaskManagementPage> createState() => _AdminTaskManagementPageState();
}

class _AdminTaskManagementPageState extends State<AdminTaskManagementPage> {
  final TaskController _taskController = TaskController();
  late Future<List<Map<String, dynamic>>> _tasksWithEventNamesFuture;

  @override
  void initState() {
    super.initState();
    _tasksWithEventNamesFuture = _taskController.fetchTasksWithEventNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tasksWithEventNamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasksWithEventNames = snapshot.data ?? [];
          if (tasksWithEventNames.isEmpty) {
            return const Center(child: Text("No tasks available."));
          }

          return ListView.builder(
            itemCount: tasksWithEventNames.length,
            itemBuilder: (context, index) {
              final task = tasksWithEventNames[index]['task'] as Task;
              final eventName = tasksWithEventNames[index]['eventName'] as String;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text(
                    "Description: ${task.description}\nEvent: $eventName",
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
