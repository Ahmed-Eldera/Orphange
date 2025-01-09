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
import 'command.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreDatabaseService _dbservice = FirestoreDatabaseService();

  // Existing methods remain unchanged
  Future<List<Event>?> fetchEvents(String type) async {
    List<Event>? events = await _dbservice.fetchEvents(type);
    return events;
  }

  Future<void> notifyAllUsers(String message) async {
    DonorController donorController = DonorController();
    VolunteerController volunteerController = VolunteerController();
    CommunicationContext context = CommunicationContext();
    List<Donor> donors = await donorController.getAllDonors();
    List<Volunteer> volunteers = await volunteerController.getAllVolunteers();

    for (Donor donor in donors) {
      context.fastsend(donor.id, message);
    }

    for (Volunteer volunteer in volunteers) {
      context.fastsend(volunteer.id, message);
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      EventAdapter adapter = EventAdapter(event);
      await _firestore.collection('events').doc(event.id).update(adapter.ToFireStore());
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await FirebaseFirestore.instance.collection('events').doc(eventId).delete();
    } catch (e) {
      throw Exception('Failed to delete event: $e');
    }
  }

  Future<void> saveEvent(DocumentReference eventDocRef, Event event) async {
    try {
      EventAdapter adapter = EventAdapter(event);
      await eventDocRef.set(adapter.ToFireStore());
      notifyAllUsers("${event.name} is created, check it out!");
    } catch (e) {
      throw Exception('Failed to save event: $e');
    }
  }

  Future<void> saveTask(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(task.eventId)
          .collection('tasks')
          .doc(task.id)
          .set(task.toMap());
      print("Task ${task.name} saved successfully under event ${task.eventId}.");
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }

  // NEW: Execute Command
  Future<void> executeCommand(Command command) async {
    try {
      await command.execute();
      print('Command executed successfully: ${command.runtimeType}');
    } catch (e) {
      throw Exception('Failed to execute command: $e');
    }
  }
  Future<void> deleteTasksByEventId(String eventId) async {
    try {
      // Fetch all tasks under the event's sub-collection
      final tasksSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('tasks')
          .get();

      // Iterate over the tasks and delete them
      for (var taskDoc in tasksSnapshot.docs) {
        await taskDoc.reference.delete();
      }

      print('All tasks under event $eventId have been deleted.');
    } catch (e) {
      throw Exception('Failed to delete tasks for event $eventId: $e');
    }
  }

}
