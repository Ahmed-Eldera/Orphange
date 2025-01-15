import 'package:flutter/material.dart';
import '../../controllers/volunteer_controller.dart';

class CreateRequestPage extends StatefulWidget {
  final String taskId;
  final String eventId;

  const CreateRequestPage({Key? key, required this.taskId, required this.eventId}) : super(key: key);

  @override
  State<CreateRequestPage> createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final _detailsController = TextEditingController();
  final VolunteerController _controller = VolunteerController();
  bool _isSubmitting = false;

  Future<void> _submitRequest() async {
    if (_detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request details cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _controller.submitRequest(
        widget.taskId,
        widget.eventId,
        _detailsController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit request: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Request"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Submit a Request for the Task",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: "Request Details",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitRequest,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
