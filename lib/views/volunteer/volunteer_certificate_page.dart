import 'package:flutter/material.dart';
import '../../controllers/volunteer_controller.dart';

class VolunteerCertificatePage extends StatelessWidget {
  final VolunteerController _controller = VolunteerController();

  VolunteerCertificatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Certificate'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _controller.fetchCertificateData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final name = data['name'] as String? ?? 'Volunteer';
          final tasks = data['tasks'] as List;
          final approvedRequests = data['approvedRequests'] as List;
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
                    'Email: ${data['email']}',
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
                    title: Text(task['name']),
                    subtitle: Text(task['description']),
                  )),
                  const SizedBox(height: 16),
                  const Text(
                    'Approved Requests:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...approvedRequests.map((request) => ListTile(
                    title: Text('Task ID: ${request['taskId']}'),
                    subtitle: Text('Details: ${request['details']}'),
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
