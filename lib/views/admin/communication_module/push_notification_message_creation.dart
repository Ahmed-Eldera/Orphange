import 'package:flutter/material.dart';
import 'package:hope_home/controllers/volunteer_controller.dart';
import 'package:hope_home/models/users/volunteer.dart';
import '../../../controllers/communication_context.dart';
import '../../../models/communication_strats/push_notification_strategy.dart';
import '../../../controllers/donor_controller.dart';
import '../../../models/users/donor.dart';

class PushNotificationMessageCreationPage extends StatefulWidget {
  const PushNotificationMessageCreationPage({Key? key}) : super(key: key);

  @override
  _PushNotificationMessageCreationPageState createState() =>
      _PushNotificationMessageCreationPageState();
}

class _PushNotificationMessageCreationPageState
    extends State<PushNotificationMessageCreationPage> {
  final CommunicationContext _context = CommunicationContext();
  final DonorController _donorController = DonorController();
  final TextEditingController _messageController = TextEditingController();

  String? _selectedUserId;
  List<Donor> _donors = [];
    final VolunteerController _volunteerController = VolunteerController();
  List<Volunteer> _volunteers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });
    _donors = await _donorController.getAllDonors();
    _volunteers = await _volunteerController.getAllVolunteers();
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Donor'),
              items:  [
    ..._donors.map(
      (donor) => DropdownMenuItem(
        value: donor.id, // Use a prefix to distinguish donors
        child: Text('Donor: ${donor.name}'),
      ),
    ),
    ..._volunteers.map(
      (volunteer) => DropdownMenuItem(
        value: volunteer.id, // Use a prefix to distinguish volunteers
        child: Text('Volunteer: ${volunteer.name}'),
      ),
    ),
  ].toList(),

              onChanged: (value) {
                setState(() {
                  _selectedUserId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Notification Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }


  void _sendMessage() {
    if (_selectedUserId == null || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // final selectedUser = _donors.firstWhere((donor) => donor.id == _selectedUserId);
    _context.send(PushNotificationStrategy(),_selectedUserId!, _messageController.text, 'Push Notification');
    // _context.setStrategy(Push NotificationStrategy());
    // _context.executeStrategy(selectedUser.name, _messageController.text, 'Push Notification');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Push Notification sent Successfully')),
    );
  }
}
