import 'package:flutter/material.dart';
import '../../controllers/message_controller.dart';
import '../../userProvider.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final MessageController _messageController = MessageController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch the current user ID
    UserProvider userProvider = UserProvider();
    String userId = userProvider.currentUser!.id;

    // Use the controller to fetch messages
    _messages = await _messageController.fetchMessages(userId);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
          ? const Center(child: Text('No messages found'))
          : ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return _buildMessageCard(_messages[index]);
        },
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${message['type']}',
              style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${message['timestamp'].toDate()}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
