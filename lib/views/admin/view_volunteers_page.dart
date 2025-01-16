import 'package:flutter/material.dart';
import '../../controllers/volunteer_controller.dart';
import '../../models/users/volunteer.dart';

class ViewVolunteersPage extends StatelessWidget {
  final VolunteerController _volunteerController = VolunteerController();

  ViewVolunteersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteers'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Volunteer>>(
        future: _volunteerController.getAllVolunteers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No volunteers available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final volunteers = snapshot.data!;
          return ListView.builder(
            itemCount: volunteers.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemBuilder: (context, index) {
              return _buildVolunteerCard(volunteers[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildVolunteerCard(Volunteer volunteer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(volunteer.name, volunteer.id),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, volunteer.email),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(String name, String id) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'ID: $id',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
