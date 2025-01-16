// lib/controllers/commands/delete_event_command.dart
import '../../controllers/event_controller.dart';
import 'command.dart';

class DeleteEventCommand implements Command {
  final EventController eventController;
  final String eventId;

  // Constructor to accept eventController and eventId
  DeleteEventCommand({
    required this.eventController,
    required this.eventId,
  });

  @override
  Future<void> execute() async {
    // Delete the event
    await eventController.deleteEvent(eventId);

    // Delete associated tasks
    await eventController.deleteTasksByEventId(eventId);
  }
}
