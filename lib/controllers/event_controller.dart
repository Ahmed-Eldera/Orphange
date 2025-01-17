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
import '../models/command_pattern/command.dart';
import '../models/command_pattern/create event command.dart';
import '../models/command_pattern/delete event command.dart';

class EventController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreDatabaseService _dbservice = FirestoreDatabaseService();

  // Existing methods remain unchanged
  Future<List<Event>?> fetchEvents(String type) async {
    List<Event>? events = await _dbservice.fetchEvents(type);
    return events;
  }
  Future<List<String>> fetchEventNames() async {
    try {
      final snapshot = await _firestore.collection('events').get();
      return snapshot.docs.map((doc) => doc.data()['name']?.toString() ?? 'Unnamed Event').toList();
    } catch (error) {
      print('Error fetching event names: $error');
      return [];
    }
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
  DocumentReference getEventDocRef() {
    return _firestore.collection('events').doc();
  }

  String getEventId(DocumentReference eventDocRef) {
    return eventDocRef.id;
  }
  Future<List<Event>> fetchAllEvents() async {
    try {
      return await _dbservice.fetchAllEvents();
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Failed to fetch events');
    }
  }

  Future<void> createEvent({
    required String name,
    required String description,
    required String date,
    required int attendance,
    required List<Task> tasks,
  }) async {
    final eventDocRef = getEventDocRef();
    final eventId = getEventId(eventDocRef);

    final event = Event(
      id: eventId,
      name: name,
      description: description,
      date: date,
      attendance: attendance,
    );

    final createCommand = CreateEventCommand(
      eventController: this,
      eventDocRef: eventDocRef,
      event: event,
      tasks: tasks,
    );

    await executeCommand(createCommand);
  }

  Future<void> deleteEventWithTasks(String eventId) async {
    final deleteCommand = DeleteEventCommand(
      eventController: this,
      eventId: eventId,
    );

    await executeCommand(deleteCommand);
  }

}
