import 'package:flutter/material.dart';
import '../../controllers/volunteer_controller.dart';
import '../../models/Event/request.dart';

class EditRequestPage extends StatefulWidget {
  final Request request;

  const EditRequestPage({Key? key, required this.request}) : super(key: key);

  @override
  _EditRequestPageState createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  late TextEditingController _detailsController;
  final VolunteerController _controller = VolunteerController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController(text: widget.request.details);
  }

  Future<void> _saveChanges() async {
    if (_detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Details cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      widget.request.details = _detailsController.text.trim();
      await _controller.updateRequestDetails(widget.request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request updated successfully')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update request: $error')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Request"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Edit Request Details",
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
              enabled: widget.request.canEdit(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.request.canEdit() && !_isSaving ? _saveChanges : null,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text("Save Changes"),
            ),
            if (!widget.request.canEdit())
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Request cannot be edited as it is already approved.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
