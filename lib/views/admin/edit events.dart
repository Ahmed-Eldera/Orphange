import 'package:flutter/material.dart';
import '../../models/Event/event.dart';
import '../../controllers/event_controller.dart';

class EditEventDetailPage extends StatefulWidget {
  final Event event;

  const EditEventDetailPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventDetailPageState createState() => _EditEventDetailPageState();
}

class _EditEventDetailPageState extends State<EditEventDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _eventController = EventController();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _attendanceController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = TextEditingController(text: widget.event.description);
    _dateController = TextEditingController(text: widget.event.date);
    _attendanceController = TextEditingController(text: widget.event.attendance.toString());
  }

  Future<void> _saveEditedEvent() async {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = Event(
        id: widget.event.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _dateController.text.trim(),
        attendance: int.parse(_attendanceController.text.trim()), tasks: [],
      );

      try {
        await _eventController.updateEvent(updatedEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully!')),
        );
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event: $e')),
        );
      }
    }
  }

  Future<void> _deleteEvent() async {
    final shouldDelete = await _confirmDeletion();
    if (shouldDelete) {
      try {
        await _eventController.deleteEventWithTasks(widget.event.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully!')),
        );
        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete event: $e')),
        );
      }
    }
  }

  Future<bool> _confirmDeletion() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    ) ??
        false;
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
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter a date' : null,
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _attendanceController,
                decoration: const InputDecoration(labelText: 'Expected Attendance'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || int.tryParse(value) == null
                    ? 'Please enter a valid number'
                    : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveEditedEvent,
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _deleteEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
