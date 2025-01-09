import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controllers/event controller.dart';
import '../../models/Event/event.dart';
import '../../models/Event/task.dart';

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
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _addTask() {
    final String taskName = _taskNameController.text.trim();
    final String taskDescription = _taskDescriptionController.text.trim();

    if (taskName.isEmpty || taskDescription.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all task fields')),
      );
      return;
    }

    setState(() {
      _tasks.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        eventId: '', // Will be set after the event is created
        name: taskName,
        description: taskDescription,
      ));
    });

    _taskNameController.clear();
    _taskDescriptionController.clear();
    Navigator.pop(context); // Close the dialog
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      // Get a new document reference with an auto-generated ID
      final eventDocRef = FirebaseFirestore.instance.collection('events').doc();
      final eventId = eventDocRef.id; // Get the auto-generated ID

      // Create the Event object
      Event event = Event(
        id: eventId,
        name: _nameController.text,
        description: _descriptionController.text,
        date: _dateController.text,
        attendance: int.parse(_attendanceController.text),
      );

      // Save the Event
      _eventController.saveEvent(eventDocRef, event).then((_) {
        // Save tasks under this event
        for (var task in _tasks) {
          task.eventId = eventId; // Assign the event ID to the task
          _eventController.saveTask(task).then((_) {
            print("Task ${task.name} saved successfully under event $eventId.");
          }).catchError((error) {
            print("Failed to save task ${task.name}: $error");
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event and tasks created successfully!')),
        );

        Navigator.pop(context); // Go back after saving
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event: $error')),
        );
      });
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
                subtitle: Text(task.description),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
