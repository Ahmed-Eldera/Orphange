import '../../models/Event/event.dart';
import '../../models/db_handlers/FireStore.dart';

class AdminController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<List<Event>> fetchEvents() async {
    try {
      return await _dbService.fetchAllEvents();
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Failed to fetch events');
    }
  }
}
