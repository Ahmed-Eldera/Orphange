import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/volunteer_controller.dart';
import '../../models/Event/task.dart';
class LogHoursPage extends StatelessWidget {
  final List<Task> tasks; // Add tasks as a parameter
  final String eventId;   // Add eventId as a parameter

  // Constructor to accept the tasks and eventId
  LogHoursPage({required this.tasks, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Hours'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Task>>(
        future: _fetchApprovedTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return const Center(child: Text("No approved tasks available."));
          }

          // Calculate total hours for approved tasks
          final totalHours = tasks.fold(0, (sum, task) => sum + task.hours);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Hours Logged: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$totalHours hours",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Task ID: ${task.id}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Hours: ${task.hours}",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Event ID: ${task.eventId}",
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Task>> _fetchApprovedTasks() async {
    // This is just an example, modify based on your needs
    return tasks.where((task) => task.status == "approved" && task.eventId == eventId).toList();
  }
}
