import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/views/admin/admin_request_management_page.dart';
import '../donor/all_donations_page.dart';
import 'admin_task_management_page.dart';
import 'beneficiaries_list.dart';
import '../../../../models/Event/event.dart';
import 'communication_module/communication_page.dart';
import 'create event.dart';
import 'donor_list_page.dart';
import 'edit events.dart';

class AdminDashboard extends StatefulWidget {
  final Map<String, dynamic> admin;

  const AdminDashboard({Key? key, required this.admin}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // Fetch the events when the page loads
  }

  // Fetch events from Firestore
  void _fetchEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      final eventList = snapshot.docs
          .map((doc) => Event.fromMap(doc.data(), doc.id))
          .toList();
      setState(() {
        _events = eventList;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: $error')),
      );
    }
  }

  // Navigate to EditEventDetailPage with the selected event
  void _editEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventDetailPage(event: event), // Pass the selected event
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard - ${widget.admin['name']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardButton(
                  'Assign Tasks',
                  Icons.assignment,
                      () {
                    _navigateToEmptyPage(context, 'Assign Tasks Page');
                  },
                ),
                _buildDashboardButton(
                  'Create Events',
                  Icons.add_circle,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateEventPage()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'Edit Events',
                  Icons.edit,
                      () {
                    // Check if events are available before navigating
                    if (_events.isNotEmpty) {
                      // Navigate to EditEventPage which lists all events
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEventPage(events: _events),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No events available to edit')),
                      );
                    }
                  },
                ),
                _buildDashboardButton(
                  'Track Volunteers',
                  Icons.people,
                      () {
                    _navigateToEmptyPage(context, 'Track Volunteers Page');
                  },
                ),
                _buildDashboardButton(
                  'Manage Donations',
                  Icons.attach_money,
                      () {
                    _navigateToEmptyPage(context, 'Manage Donations Page');
                  },
                ),
                _buildDashboardButton(
                  'View Donors',
                  Icons.people_alt, // Use a different icon to differentiate
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DonorListPage(),
                      ),
                    );
                  },
                ),
                _buildDashboardButton(
                  'Send Message',
                  Icons.message,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunicationPage(),
                      ),
                    );
                  },
                ),
                _buildDashboardButton(
                  'View All Donations',
                  Icons.monetization_on,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllDonationsPage()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'Manage Tasks',
                  Icons.task,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminTaskManagementPage(), // Replace with actual event ID
                      ),
                    );
                  },
                ),
                _buildDashboardButton(
                  "Manage Requests",
                  Icons.request_page,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminRequestManagementPage(), // Replace with actual event ID
                      ),
                    );
                  },
                ),
                _buildDashboardButton(
                  'Manage Beneficiaries',
                  Icons.child_care,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BeneficiariesListPage(),
                      ),
                    );
                  },
                ),



              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToEmptyPage(BuildContext context, String pageTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmptyPage(title: pageTitle),
      ),
    );
  }
}

class EditEventPage extends StatelessWidget {
  final List<Event> events;

  const EditEventPage({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Events'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5,
            child: ListTile(
              title: Text(event.name),
              subtitle: Text(event.date),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigate to EditEventDetailPage for the selected event
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventDetailPage(event: event),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmptyPage extends StatelessWidget {
  final String title;

  const EmptyPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Text(
          '$title is under development.',
          style: const TextStyle(fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
