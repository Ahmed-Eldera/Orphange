import 'package:flutter/material.dart';
import 'package:hope_home/controllers/profileController.dart';
import 'package:hope_home/models/user.dart';
import 'package:hope_home/userProvider.dart';
import 'package:hope_home/views/show_events.dart';
import 'package:provider/provider.dart';
import 'donation_history_page.dart';
import '../inbox_page.dart';
import '../../models/Donation/donor_receipt.dart';
import 'make_donation_page.dart';
import 'registerTicket.dart';
class DonorDashboard extends StatelessWidget {


  const DonorDashboard({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    myUser donor = userProvider.currentUser!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Donor Dashboard - ${donor.name}',
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
                  builder: (context) => ProfilePlaceholderPage(),
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
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketRegistrationPage()),
                          );


                        },
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
                        MaterialPageRoute(builder: (context) => DonationHistoryPage(donorEmail: donor.email)),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    'Generate Receipt',
                    Icons.receipt_long,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptPage(donorEmail: donor.email),
                        ),
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
  final UserProvider userProvider = UserProvider();
  final Profilecontroller profilecontroller = Profilecontroller();
  final TextEditingController usernameController = TextEditingController();

  ProfilePlaceholderPage({Key? key}) : super(key: key);

  Future<void> _saveProfileChanges(BuildContext context) async {
    try {
      // Await the update operation
      await profilecontroller.updateuser(usernameController.text, userProvider.currentUser!);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      // Show error snackbar if the operation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    myUser donor = userProvider.currentUser!;
    usernameController.text = donor.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveProfileChanges(context),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




