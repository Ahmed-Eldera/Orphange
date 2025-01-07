import 'package:hope_home/models/db_handlers/FireStore.dart';
import 'package:hope_home/models/event.dart';

class EventsProxy {
  final FirestoreDatabaseService _firestoreDatabaseService = FirestoreDatabaseService();

  // Proxy method to fetch events based on user type
  Future<List<Event>?> fetchEvents(String userType) async {
    // If the user is not an Admin, apply filtering for events happening this week
    if (userType != 'Admin') {
      return await _fetchEventsForUser();
    } else {
      // For Admin, fetch all events
      return await _firestoreDatabaseService.fetchAllEvents();
    }
  }























  // Method for non-admin users, applying the week filter
  Future<List<Event>?> _fetchEventsForUser() async {
    try {
      // Fetch all events from Firestore
      final events = await _firestoreDatabaseService.fetchAllEvents();
      return _filterEventsForThisWeek(events!); // Filter to show only events happening this week
    } catch (e) {
      print('Error fetching events for user: $e');
      return [];
    }
  }

  // Filter events to only include those happening this week
  List<Event> _filterEventsForThisWeek(List<Event> events) {
    print(events);
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: 1)); // Start of this week (Monday)
    final endOfWeek = startOfWeek.add(Duration(days: 7)); // End of this week (Sunday)
    List<Event> filtered = events.where((event) {
      DateTime eventDate = DateTime.parse(event.date); // Assuming event.date is in a parsable format
      return eventDate.isAfter(startOfWeek) && eventDate.isBefore(endOfWeek);
    }).toList();
    print(filtered);
    return filtered;
  }
}
