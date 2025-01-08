import 'package:flutter/material.dart';
import 'package:hope_home/userProvider.dart';
import '../../controllers/event controller.dart';
import '../../models/Event/event.dart';
import '../event_page.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _attendanceController = TextEditingController();
  final EventController _eventController = EventController();

  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"; // Format date as YYYY-MM-DD
      });
    }
  }

  void _saveEventToFirebase(Event event) async {
    try {
      await _eventController.saveEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $error')),
      );
    }
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      Event event = Event(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        attendance: int.parse(_attendanceController.text),
      );
      _saveEventToFirebase(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        icon: Icon(Icons.event),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a name'
                          : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        icon: Icon(Icons.description),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a description'
                          : null,
                    ),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true, // Make the field non-editable
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        icon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context), // Open the DatePicker
                      validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Please select a date'
                              : null,
                    ),
                    TextFormField(
                      controller: _attendanceController,
                      decoration: const InputDecoration(
                        labelText: 'Expected Attendance',
                        icon: Icon(Icons.people),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || int.tryParse(value) == null
                              ? 'Please enter a valid number'
                              : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _createEvent,
                icon: const Icon(Icons.save),
                label: const Text("Create Event"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  backgroundColor: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Event List",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              buildEventList(_eventController),
            ],
          ),
        ),
      ),
    );
  }
}
