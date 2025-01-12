import 'package:flutter/material.dart';
import 'package:hope_home/models/Event/task.dart';
import 'create_request_page.dart';

class ViewTasksPage extends StatefulWidget {
  final List<Task> tasks; // Pass tasks to this page

  const ViewTasksPage({Key? key, required this.tasks}) : super(key: key);

  @override
  State<ViewTasksPage> createState() => _ViewTasksPageState();
}

class _ViewTasksPageState extends State<ViewTasksPage> {
  // A map to keep track of the status of each task request
  final Map<String, String> _taskRequestStatuses = {};

  void _requestTask(Task task) {
    setState(() {
      _taskRequestStatuses[task.id] = "Pending"; // Mark the task as requested with "Pending" status
    });

    // Navigate to the request page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRequestPage(
          taskId: task.id,
          eventId: task.eventId,
        ),
      ),
    ).then((_) {
      // Optionally handle any actions after returning from the request page
      // Simulate admin response for demo purposes (update this in real use cases)
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _taskRequestStatuses[task.id] = "Approved"; // Update status to "Approved" or "Rejected"
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Tasks'),
        backgroundColor: Colors.blue,
      ),
      body: widget.tasks.isEmpty
          ? const Center(child: Text("No tasks available."))
          : ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (context, index) {
          final task = widget.tasks[index];
          final taskStatus = _taskRequestStatuses[task.id];

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
                        task.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Event ID: ${task.eventId}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Hours: ${task.hours}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: taskStatus == "Pending" || taskStatus == "Approved"
                          ? null // Disable button if already requested or approved
                          : () => _requestTask(task),
                      icon: const Icon(Icons.add),
                      label: Text(
                        taskStatus == "Pending"
                            ? "Request Sent"
                            : taskStatus == "Approved"
                            ? "Approved"
                            : "Request",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: taskStatus == "Pending" || taskStatus == "Approved"
                            ? Colors.grey
                            : Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
