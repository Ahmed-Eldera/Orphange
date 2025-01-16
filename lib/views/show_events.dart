import 'package:flutter/material.dart';
import 'package:hope_home/controllers/event_controller.dart';
import 'package:hope_home/models/iterators/event_collection.dart';
import 'package:hope_home/models/Event/event.dart';

class ShowEvents extends StatelessWidget {
  const ShowEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventController _eventController = EventController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Event>?>(
          future: _eventController.fetchAllEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No events found.'));
            }

            // Use the EventList and EventListIterator
            final eventList = EventList();
            snapshot.data!.forEach(eventList.addEvent);

            final iterator = eventList.createIterator();
            final List<Widget> eventWidgets = [];
            while (iterator.hasNext()) {
              final event = iterator.next();
              eventWidgets.add(EventCard(event: event));
            }

            return ListView(
              children: eventWidgets,
            );
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.event, color: Colors.blue),
                  onPressed: () {
                    // Add event-specific action here
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text(
                  event.date,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (event.description.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
