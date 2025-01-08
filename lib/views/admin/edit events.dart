import 'package:flutter/material.dart';
import '../../models/Event/event.dart';
import '../../controllers/event controller.dart'; // Ensure correct import

class EditEventPage extends StatefulWidget {
  const EditEventPage({Key? key}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _eventController = EventController(); // Controller to manage events
  List<Event>? _events = []; // List to store events from Firestore

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // Fetch events from Firestore
  void _fetchEvents() async {
    try {
      final eventList = await _eventController.fetchEvents("Admin");
      setState(() {
        _events = eventList; // Update the list of events
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: $error')),
      );
    }
  }

  // Navigate to EditEventDetailPage to edit the event
  void _editEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventDetailPage(event: event), // Pass event to edit
      ),
    );
  }

  // Build the list of events as clickable boxes (cards)
  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _events!.length,
      itemBuilder: (context, index) {
        final event = _events![index];
        return GestureDetector(
          onTap: () => _editEvent(event), // Navigate to edit when tapped
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(event.name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Date: ${event.date}\nDescription: ${event.description}'),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Events'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _events!.isEmpty
            ? Center(child: CircularProgressIndicator()) // Show loading indicator if events are empty
            : _buildEventList(), // Display the list of events as clickable boxes
      ),
    );
  }
}

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
            ],
          ),
        ),
      ),
    );
  }
}
