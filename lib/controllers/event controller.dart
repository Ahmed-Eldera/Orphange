import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hope_home/controllers/communication_context.dart';
import 'package:hope_home/controllers/donor_controller.dart';
import 'package:hope_home/controllers/volunteer_controller.dart';
import 'package:hope_home/models/Event/eventAdapter.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/users/donor.dart';
import 'package:hope_home/models/users/volunteer.dart';
import '../models/Event/event.dart';
import '../models/Event/task.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreDatabaseService _dbservice = FirestoreDatabaseService();
  // Fetch events from Firestore
  Future<List<Event>?> fetchEvents(String type) async {
    List<Event>? events = await _dbservice.fetchEvents(type);
    return events;
  }
Future<void> notifyAllUsers(String message) async {
  DonorController donorController = DonorController();
  VolunteerController volunteerController = VolunteerController();
  CommunicationContext context =CommunicationContext();
  List<Donor> donors = await donorController.getAllDonors();
  List<Volunteer> volunteers = await volunteerController.getAllVolunteers();

  for (Donor donor in donors) {
    context.fastsend(donor.id, message);
  }

  // Iterate over volunteers and perform an action
  for (Volunteer volunteer in volunteers) {
    context.fastsend(volunteer.id, message);
  }
}

  // Update event in Firestore
  Future<void> updateEvent(Event event) async {
    try {
      EventAdapter adapter = EventAdapter(event);
      await _firestore.collection('events').doc(event.id).update(adapter.ToFireStore());
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
  Future<void> saveEvent(DocumentReference eventDocRef, Event event) async {
    try {
      EventAdapter adapter = EventAdapter(event);
      await eventDocRef.set(adapter.ToFireStore()); // Save the event using the generated ID
      notifyAllUsers(event.name + " is created, check it out!");
    } catch (e) {
      throw Exception('Failed to save event: $e');
    }
  }


  Future<void> saveTask(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(task.eventId) // Use the event ID as the parent document
          .collection('tasks') // Save task in the sub-collection
          .doc(task.id) // Task document ID
          .set(task.toMap());
      print("Task ${task.name} saved successfully under event ${task.eventId}.");
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }

}
