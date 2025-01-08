import 'package:flutter/material.dart';
import 'package:hope_home/views/show_events.dart';
import 'donation_history_page.dart';
import '../inbox_page.dart';
import 'make_donation_page.dart';

class DonorDashboard extends StatelessWidget {
  final Map<String, dynamic> donor;

  const DonorDashboard({Key? key, required this.donor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Donor Dashboard - ${donor['name']}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePlaceholderPage(donor: donor),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                        MaterialPageRoute(
                          builder: (context) => ShowEvents()),
                        );
                      },
                  ),
                  _buildDashboardButton(
                    'Register a Ticket',
                    Icons.confirmation_num,
                        () {},
                  ),
                  _buildDashboardButton(
                    'Donate',
                    Icons.volunteer_activism,
                        () {},
                  ),
                  _buildDashboardButton(
                    'Inbox',
                    Icons.inbox,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InboxPage(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    'Make a Donation',
                    Icons.volunteer_activism,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MakeDonationPage(donor: donor)),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    'Donation History',
                    Icons.history,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DonationHistoryPage(donorEmail: donor['email'])),
                      );
                    },
                  ),


                ],
              ),
            ],
          ),
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
}

class ProfilePlaceholderPage extends StatelessWidget {
  final Map<String, dynamic> donor;

  const ProfilePlaceholderPage({Key? key, required this.donor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Text(
          'Donor Name: ${donor['name']}\nEmail: ${donor['email']}',
          style: const TextStyle(fontSize: 18, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
