import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/volunteer_controller.dart';
import '../../models/Event/task.dart';
import '../../models/Event/request.dart';
class VolunteerCertificatePage extends StatelessWidget {
  final VolunteerController _controller = VolunteerController();

  Future<Map<String, dynamic>> _fetchCertificateData(String email) async {
    final name = await _controller.fetchVolunteerName(email);
    final tasks = await _controller.fetchTasksParticipated(email);
    final approvedRequests = await _controller.fetchApprovedRequests(email);
    final hours = await _controller.calculateVolunteerHours(email);

    return {
      'name': name,
      'tasks': tasks,
      'approvedRequests': approvedRequests,
      'hours': hours,
    };
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('User not logged in'));
    }

    final email = user.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Certificate'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchCertificateData(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final name = data['name'] as String? ?? 'Volunteer';
          final tasks = data['tasks'] as List<Task>;
          final approvedRequests = data['approvedRequests'] as List<Request>;
          final hours = data['hours'] as int;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Certificate of Achievement',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Presented to $name',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: $email',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Appreciation Note',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thank you for your dedication and effort. Your contribution has made a significant impact on our community.',
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Tasks Participated In:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...tasks.map((task) => ListTile(
                    title: Text(task.name),
                    subtitle: Text(task.description),
                  )),
                  const SizedBox(height: 16),
                  const Text(
                    'Approved Requests:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...approvedRequests.map((request) => ListTile(
                    title: Text('Task ID: ${request.taskId}'),
                    subtitle: Text('Details: ${request.details}'),
                  )),
                  const SizedBox(height: 16),
                  Text(
                    'Total Tracked Hours: $hours hours',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
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
