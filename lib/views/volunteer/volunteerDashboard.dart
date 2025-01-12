import 'package:flutter/material.dart';
import 'package:hope_home/views/inbox_page.dart';
import 'package:hope_home/views/show_events.dart';
import 'package:hope_home/views/volunteer/volunteer_request_page.dart';
import '../../controllers/volunteer_controller.dart';
import '../../models/db_handlers/FireStore.dart';
import 'view_tasks_page.dart';
import 'volunteer_certificate_page.dart';

class VolunteerDashboard extends StatelessWidget {
  final VolunteerController _controller = VolunteerController();
  VolunteerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Volunteer Dashboard',
          style: TextStyle(
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
                  'View Events',
                  Icons.event,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowEvents()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'View Tasks',
                  Icons.task,
                      () async {
                    final tasks = await  _controller.fetchAllTasks();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewTasksPage(tasks: tasks),
                      ),
                    );
                  },
                ),
                _buildDashboardButton(
                  'My Requests',
                  Icons.request_page,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VolunteerRequestsPage()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'Log Hours',
                  Icons.timer,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogHoursPage()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'View Messages',
                  Icons.message,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InboxPage()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'View History',
                  Icons.history,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewHistoryPage()),
                    );
                  },
                ),
                _buildDashboardButton(
                  'Generate Certificate',
                  Icons.card_giftcard,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VolunteerCertificatePage()),
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
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LogHoursPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Start Hours'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(child: Text('Log hours functionality will be here.')),
    );
  }
}



class ViewHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View History'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(child: Text('History will be displayed here.')),
    );
  }
}
