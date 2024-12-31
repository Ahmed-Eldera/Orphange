import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch events from Firestore
  Future<List<Event>> fetchEvents() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data(), doc.id); // Pass doc.id along with doc.data()
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  // Update event in Firestore
  Future<void> updateEvent(Event event) async {
    try {
      await _firestore.collection('events').doc(event.id).update(event.toJson());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }Future<void> deleteEvent(String eventId) async {
    // Your logic to delete the event, e.g., from Firestore or your data source
    try {
      // Example Firestore code to delete an event
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }
  // Save event to Firestore
  Future<void> saveEvent(Event event) async {
    try {
      await _firestore.collection('events').add(event.toJson());
    } catch (e) {
      throw Exception('Failed to save event: $e');
    }
  }
}
