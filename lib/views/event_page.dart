  import 'package:flutter/material.dart';
import 'package:hope_home/models/Event/event.dart';
import 'package:hope_home/userProvider.dart';
import '../../models/iterators/event collection.dart';
import '../../controllers/event controller.dart';
Widget buildEventList(EventController EventController) {
  UserProvider userProvider = UserProvider();
  String type = userProvider.currentUser!.type;
    return FutureBuilder<List<Event>?>(
      future: EventController.fetchEvents(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No events found.'));
        } else {
          final eventList = EventList();
          snapshot.data!.forEach(eventList.addEvent);

          final iterator = eventList.createIterator();
          final List<Widget> eventWidgets = [];
          while (iterator.hasNext()) {
            final event = iterator.next();
            eventWidgets.add(
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 5,
                child: ListTile(
                  title: Text(event.name),
                  subtitle: Text(
                    "Date: ${event.date}\nDescription: ${event.description}",
                  ),
                ),
              ),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: eventWidgets,
          );
        }
      },
    );
  }