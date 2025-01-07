import 'package:flutter/material.dart';
import '../../../controllers/communication_context.dart';
import '../../../models/communication_strats/sms_strategy.dart';
import '../../../controllers/donor_controller.dart';
import '../../../models/users/donor.dart';

class SmsMessageCreationPage extends StatefulWidget {
  const SmsMessageCreationPage({Key? key}) : super(key: key);

  @override
  _SmsMessageCreationPageState createState() => _SmsMessageCreationPageState();
}

class _SmsMessageCreationPageState extends State<SmsMessageCreationPage> {
  final CommunicationContext _context = CommunicationContext();
  final DonorController _donorController = DonorController();
  final TextEditingController _messageController = TextEditingController();

  String? _selectedDonorId;
  List<Donor> _donors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonors();
  }

  Future<void> _loadDonors() async {
    setState(() {
      _isLoading = true;
    });
    _donors = await _donorController.getAllDonors();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Message'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Donor'),
              items: _donors
                  .map((donor) => DropdownMenuItem(
                value: donor.id,
                child: Text(donor.name),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDonorId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'SMS Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Send SMS'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_selectedDonorId == null || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final selectedDonor = _donors.firstWhere((donor) => donor.id == _selectedDonorId);
    _context.send(SmsStrategy(),selectedDonor.id, _messageController.text, 'SMS');
    // _context.setStrategy(SmsStrategy());
    // _context.executeStrategy(selectedDonor.name, _messageController.text, 'SMS');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SMS sent to ${selectedDonor.name}')),
    );
  }
}
