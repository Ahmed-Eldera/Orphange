import 'package:cloud_firestore/cloud_firestore.dart';

import 'communication_strategy.dart';

class EmailStrategy implements CommunicationStrategy {
  @override
  Future<void> sendMessage(String recipient, String message, String type) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'recipient': recipient,
      'message': message,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
