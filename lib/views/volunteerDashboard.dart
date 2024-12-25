import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Dashboard'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildDashboardButton(
              context,
              'View Events',
              Icons.event,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewEventsPage()),
              ),
            ),
            _buildDashboardButton(
              context,
              'View Tasks',
              Icons.task,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewLogsPage()),
              ),
            ),
            _buildDashboardButton(
              context,
              'Log Start Hours',
              Icons.timer,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogHoursPage()),
              ),
            ),
            _buildDashboardButton(
              context,
              'Generate Certificate',
              Icons.school,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GenerateCertificatePage()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewHistoryPage()),
          );
        },
        backgroundColor: Colors.blue.shade700,
        child: Icon(Icons.history),
      ),
    );
  }

  Widget _buildDashboardButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(child: Text('Profile information will be displayed here.')),
    );
  }
}

class ViewEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Events'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(child: Text('Events will be displayed here.')),
    );
  }
}

class ViewLogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Tasks'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(child: Text('Tasks will be displayed here.')),
    );
  }
}

class LogHoursPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Start Hours'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(child: Text('Log hours functionality will be here.')),
    );
  }
}

class GenerateCertificatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Certificate'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(child: Text('Certificate generation will be here.')),
    );
  }
}

class ViewHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View History'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(child: Text('History will be displayed here.')),
    );
  }
}
