import 'package:flutter/material.dart';
import '../../models/Event/event.dart';
import '../../controllers/event_controller.dart'; // Ensure correct import
import '../../controllers/delete event command.dart'; // Ensure the command import is correct

class EditEventDetailPage extends StatefulWidget {
  final Event event;

  const EditEventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventDetailPageState createState() => _EditEventDetailPageState();
}

class _EditEventDetailPageState extends State<EditEventDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventController = EventController(); // Initialize EventController
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _attendanceController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with event data
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = TextEditingController(text: widget.event.description);
    _dateController = TextEditingController(text: widget.event.date);
    _attendanceController = TextEditingController(text: widget.event.attendance.toString());
  }

  // Save the updated event
  void _saveEditedEvent() async {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = Event(
        id: widget.event.id,
        name: _nameController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        attendance: int.parse(_attendanceController.text),
      );

      try {
        await _eventController.updateEvent(updatedEvent); // Update event in Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully!')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event: $error')),
        );
      }
    }
  }

  // Delete the event using Command Design Pattern
  void _deleteEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Execute the delete command
              DeleteEventCommand(
                  eventController: _eventController,
                  eventId: widget.event.id
              ).execute();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Event deleted successfully!')),
              );
              Navigator.pop(context); // Close the dialog and go back
              Navigator.pop(context); // Go back to the previous screen
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a date' : null,
              ),
              TextFormField(
                controller: _attendanceController,
                decoration: const InputDecoration(labelText: 'Expected Attendance'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || int.tryParse(value) == null ? 'Please enter a valid number' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveEditedEvent, // Save the event when the button is pressed
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _deleteEvent, // Delete event when pressed
                child: const Text('Delete Event', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
