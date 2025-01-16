import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  String eventId;
  final String name;
  final String description;
  final int hours;
  String status; // New property
  final String volunteerEmail; // New field for volunteer email

  Task({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.hours,
    this.status = "pending", // Default status
    required this.volunteerEmail, // Initialize volunteerEmail
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'name': name,
      'description': description,
      'hours': hours,
      'status': status,
      'volunteerEmail': volunteerEmail, // Add volunteerEmail to the map
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      eventId: map['eventId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      hours: map['hours'] ?? 0,
      status: map['status'] ?? 'pending',
      volunteerEmail: map['volunteerEmail'] ?? '', // Ensure volunteerEmail is fetched
    );
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
