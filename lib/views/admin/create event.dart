import 'package:flutter/material.dart';
import 'package:hope_home/controllers/volunteer_controller.dart';
import '../../controllers/event_controller.dart';
import '../../models/Event/event.dart';
import '../../models/Event/task.dart';
import '../../models/command_pattern/create event command.dart';

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
  final List<Task> _tasks = []; // List to store tasks
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _taskHoursController = TextEditingController(); // Controller for hours
  List<String> _volunteerEmails = [];
  DateTime? _selectedDate;

  // Add a controller for volunteer email
  final TextEditingController _volunteerEmailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchVolunteers(); // Fetch volunteer emails when the screen initializes
  }
  Future<void> _fetchVolunteers() async {
    final volunteers = await VolunteerController().getAllVolunteers();
    setState(() {
      _volunteerEmails = volunteers.map((v) => v.email).toList();
    });
  }


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
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _addTask() {
    final String taskName = _taskNameController.text.trim();
    final String taskDescription = _taskDescriptionController.text.trim();
    final String taskHoursText = _taskHoursController.text.trim();
    final int taskHours = int.tryParse(taskHoursText) ?? 0;
    final String volunteerEmail = _volunteerEmailController.text.trim(); // Get volunteer email

    if (taskName.isEmpty || taskDescription.isEmpty || taskHours <= 0 || volunteerEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all task fields with valid values')),
      );
      return;
    }

    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        eventId: '', // Will be set after the event is created
        name: taskName,
        description: taskDescription,
        hours: taskHours, // Add hours
        volunteerEmail: volunteerEmail, requests: [], // Pass the volunteer email
      ));
    });

    _taskNameController.clear();
    _taskDescriptionController.clear();
    _taskHoursController.clear();
    _volunteerEmailController.clear(); // Clear the email field
    Navigator.pop(context); // Close the dialog
  }

  void _createEvent() async {
    try {
      await _eventController.createEvent(
        name: _nameController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        attendance: int.parse(_attendanceController.text),
        tasks: _tasks,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $e')),
      );
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
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        icon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _selectDate(context),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Please select a date' : null,
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Add Task"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _taskNameController,
                            decoration: const InputDecoration(labelText: "Task Name"),
                          ),
                          TextFormField(
                            controller: _taskDescriptionController,
                            decoration: const InputDecoration(labelText: "Task Description"),
                          ),
                          TextFormField(
                            controller: _taskHoursController,
                            decoration: const InputDecoration(labelText: "Hours"),
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButtonFormField<String>(
                            value: _volunteerEmails.isNotEmpty ? _volunteerEmails.first : null,
                            items: _volunteerEmails
                                .map((email) => DropdownMenuItem(value: email, child: Text(email)))
                                .toList(),
                            onChanged: (email) {
                              _volunteerEmailController.text = email ?? '';
                            },
                            decoration: const InputDecoration(labelText: "Select Volunteer"),
                            validator: (value) => value == null || value.isEmpty
                                ? "Please select a volunteer"
                                : null,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: _addTask,
                          child: const Text("Add Task"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Task"),
              ),

              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _createEvent,
                icon: const Icon(Icons.save),
                label: const Text("Create Event"),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Tasks for this Event",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._tasks.map((task) => ListTile(
                title: Text(task.name),
                subtitle: Text("${task.description} - ${task.hours} hours"),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
