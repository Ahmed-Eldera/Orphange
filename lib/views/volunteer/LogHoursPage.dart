import 'package:flutter/material.dart';
import 'package:hope_home/controllers/volunteer_controller.dart';

class VolunteerLogHoursPage extends StatelessWidget {
  final VolunteerController _controller = VolunteerController();

  VolunteerLogHoursPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchLogHoursData() async {
    final email = await _controller.getLoggedInUserEmail();
    if (email == null) {
      throw Exception('No logged-in user found');
    }

    final approvedRequests = await _controller.fetchApprovedRequests(email);
    final hours = await _controller.calculateVolunteerHours(email);

    return {
      'approvedRequests': approvedRequests,
      'hours': hours,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Hours'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchLogHoursData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final approvedRequests = data['approvedRequests'] as List;
          final hours = data['hours'] as int;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log Hours Summary',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Display Approved Requests
                  const Text(
                    'Approved Requests:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (approvedRequests.isEmpty)
                    const Text(
                      'No approved requests yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  else
                    ...approvedRequests.map((request) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Task ID: ${request.taskId}'),
                          subtitle: Text('Details: ${request.details}'),
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 16),

                  // Display Total Hours
                  Text(
                    'Total Hours Logged: $hours hours',
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
