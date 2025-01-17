import 'package:hope_home/models/users/admin.dart';
import 'package:hope_home/userProvider.dart';

import '../../models/Event/event.dart';
import '../../models/db_handlers/FireStore.dart';
import '../models/Donation/donation.dart';

class AdminController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  Admin user = UserProvider().currentUser as Admin;
  Future<List<Event>> fetchEvents() async {
    try {
      return await _dbService.fetchAllEvents();
    } catch (e) {
      throw Exception('Failed to fetch events, $e');
    }
  }

  Future<List<Donation>> fetchAllDonations() async {
    try {
      return await user.fetchAllDonations();
    } catch (e) {
      throw Exception('Failed to fetch donations');
    }
  }
}
