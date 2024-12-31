import 'package:flutter/material.dart';
import 'package:hope_home/views/admin/communication_module/push_notification_message_creation.dart';
import 'package:hope_home/views/admin/communication_module/sms_message_creation.dart';
import 'email_message_creation.dart';


class CommunicationPage extends StatelessWidget {
  const CommunicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Communication Type'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCommunicationButton(
              context,
              'Email',
              Icons.email,
              Colors.blue,
            ),
            const SizedBox(height: 20),
            _buildCommunicationButton(
              context,
              'SMS',
              Icons.sms,
              Colors.green,
            ),
            const SizedBox(height: 20),
            _buildCommunicationButton(
              context,
              'Push Notification',
              Icons.notifications_active_outlined,
              Colors.orange,
            )

          ],
        ),
      ),
    );
  }

  Widget _buildCommunicationButton(
      BuildContext context, String type, IconData icon, Color color) {
    Widget destinationPage;

    switch (type) {
      case 'Email':
        destinationPage = const EmailMessageCreationPage();
        break;
      case 'SMS':
        destinationPage = const SmsMessageCreationPage();
        break;
      case 'Push Notification':
        destinationPage = const PushNotificationMessageCreationPage();
        break;
      default:
        throw Exception('Unknown communication type: $type');
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Text(
        type,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

}
