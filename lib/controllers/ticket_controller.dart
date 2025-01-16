import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class TicketController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> fetchEventNames() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) => doc.data()['name']?.toString() ?? 'Unnamed Event').toList();
    } catch (error) {
      print('Error fetching event names: $error');
      return [];
    }
  }

  Future<void> registerTicket(Ticket ticket) async {
    try {
      await ticket.saveToFirestore();
    } catch (error) {
      throw Exception('Failed to register ticket: $error');
    }
  }
}
