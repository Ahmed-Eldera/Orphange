import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
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
                    _navigateToEmptyPage(context, 'Create Events Page');
                  },
                ),
                _buildDashboardButton(
                  'Edit Events',
                  Icons.edit,
                      () {
                    _navigateToEmptyPage(context, 'Edit Events Page');
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

  const EmptyPage({super.key, required this.title});

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
