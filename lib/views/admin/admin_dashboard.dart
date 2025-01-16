import 'package:flutter/material.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/userProvider.dart';
import 'package:hope_home/views/admin/admin_request_management_page.dart';
import '../../controllers/admin_controller.dart';
import 'all_donations_page.dart';
import 'admin_task_management_page.dart';
import 'beneficiaries_list.dart';
import 'create event.dart'; // Import the CreateEventPage
import 'communication_module/communication_page.dart';
import 'donor_list_page.dart';
import 'edit events.dart'; // Import the donor list page
import '../../models/Event/event.dart';
import 'event_edit_page.dart';
import 'view_tickets.dart';
import 'view_volunteers_page.dart';

class AdminDashboard extends StatefulWidget {


   AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // List<Event> _events = [];
  late Future<List<Event>> _eventsFuture;
  @override
  void initState() {
    super.initState();
    _eventsFuture = AdminController().fetchEvents();
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
    final myUser admin = UserProvider().currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard - ${admin.name}',
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
                  'Submitted tickets',
                  Icons.assignment,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminTicketsPage()),
                        );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder<List<Event>>(
                          future: _eventsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Failed to load events'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No events available to edit')),
                              );
                              return const EmptyPage(title: 'No Events');
                            }

                            return EditEventPage(events: snapshot.data!);
                          },
                        ),
                      ),
                    );
                  },
                ),
                _buildDashboardButton(
                  'View Volunteers',
                  Icons.people,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewVolunteersPage()),
                    );
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
                      MaterialPageRoute(builder: (context) =>  AllDonationsPage()),
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
