import 'package:flutter/material.dart';
import 'package:hope_home/controllers/task_controller.dart';
import '../../models/Event/task.dart';

class VolunteerLogHoursPage extends StatelessWidget {
  final TaskController _taskController = TaskController();

  Future<List<Task>> _fetchLoggedHoursData() async {
    return await _taskController.fetchTasksParticipatedForLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Hours'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<List<Task>>(
        future: _fetchLoggedHoursData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks logged yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade700,
                      child: const Icon(Icons.task_alt, color: Colors.white),
                    ),
                    title: Text(
                      task.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Description: ${task.description}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hours: ${task.hours}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: task.hours > 5 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
