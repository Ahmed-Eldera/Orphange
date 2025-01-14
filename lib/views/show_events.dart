import 'package:flutter/material.dart';
import 'package:hope_home/controllers/event_controller.dart';
import 'package:hope_home/views/event_page.dart';

class ShowEvents extends StatelessWidget {
  const ShowEvents({super.key});

  @override
  Widget build(BuildContext context) {
    EventController _eventController = EventController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: Colors.blue.shade700, // Customize the AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: buildEventList(_eventController),
      ),
    );
  }
}
