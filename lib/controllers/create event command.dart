import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/Event/event.dart';
import '../../models/Event/task.dart';
import 'event controller.dart';
import 'command.dart';

class CreateEventCommand implements Command {
  final EventController eventController;
  final DocumentReference eventDocRef;
  final Event event;
  final List<Task> tasks;

  CreateEventCommand({
    required this.eventController,
    required this.eventDocRef,
    required this.event,
    required this.tasks,
  });

  @override
  Future<void> execute() async {
    // Save the event
    await eventController.saveEvent(eventDocRef, event);

    // Save all tasks associated with the event
    for (var task in tasks) {
      task.eventId = event.id; // Assign event ID to each task
      await eventController.saveTask(task);
    }
  }
}
