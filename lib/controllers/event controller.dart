import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import '../models/event.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreDatabaseService _dbservice = FirestoreDatabaseService();
  // Fetch events from Firestore
  Future<List<Event>?> fetchEvents(String type) async {
    List<Event>? events = await _dbservice.fetchEvents(type);
    return events;
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
