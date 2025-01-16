import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/ticket_controller.dart';
import '../../models/ticket.dart';


class TicketRegistrationPage extends StatefulWidget {
  const TicketRegistrationPage({Key? key}) : super(key: key);

  @override
  State<TicketRegistrationPage> createState() => _TicketRegistrationPageState();
}

class _TicketRegistrationPageState extends State<TicketRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  String? _selectedEventName;
  List<String> _eventNames = [];
  final Map<String, bool> _donationTypes = {
    'HealthCare': false,
    'School Supplies': false,
    'Entertainment': false,
  };

  final TicketController _ticketController = TicketController();

  @override
  void initState() {
    super.initState();
    _loadEventNames();
  }

  Future<void> _loadEventNames() async {
    final eventNames = await _ticketController.fetchEventNames();
    setState(() {
      _eventNames = eventNames;
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate() || _selectedEventName == null) {
      return;
    }

    final selectedDonationTypes = _donationTypes.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedDonationTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one donation type.')),
      );
      return;
    }

    final ticket = Ticket(
      id: const Uuid().v4(),
      date: DateTime.now().toIso8601String(),
      userName: _userNameController.text.trim(),
      eventName: _selectedEventName!,
      donationTypes: selectedDonationTypes,
    );

    try {
      await _ticketController.registerTicket(ticket);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket registered successfully!')),
      );
      _resetForm();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register ticket: $error')),
      );
    }
  }

  void _resetForm() {
    _userNameController.clear();
    setState(() {
      _selectedEventName = null;
      _donationTypes.updateAll((key, value) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Registration'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedEventName,
                items: _eventNames
                    .map((event) => DropdownMenuItem(
                  value: event,
                  child: Text(event),
                ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Event',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedEventName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an event';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Donation Types:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: _donationTypes.keys.map((donationType) {
                  return CheckboxListTile(
                    title: Text(donationType),
                    value: _donationTypes[donationType],
                    onChanged: (value) {
                      setState(() {
                        _donationTypes[donationType] = value!;
                      });
                    },
                    activeColor: Colors.blue.shade700,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: const Text('Register Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
