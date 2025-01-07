import 'package:hope_home/controllers/communication_context.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import '../models/users/volunteer.dart';

class VolunteerController {
  // CommunicationContext _context = CommunicationContext();
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  // Future<void>? notifyUsers(){print("");}
  Future<List<Volunteer>> getAllVolunteers() async {
    return await _dbService.fetchAllVolunteers();
  }
}
