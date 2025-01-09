import 'package:hope_home/controllers/communication_context.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import '../models/Event/request.dart';
import '../models/Event/task.dart';
import '../models/users/volunteer.dart';

class VolunteerController {
  // CommunicationContext _context = CommunicationContext();
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  // Future<void>? notifyUsers(){print("");}
  Future<List<Volunteer>> getAllVolunteers() async {
    return await _dbService.fetchAllVolunteers();
  }
  Future<List<Task>> fetchAllTasks() async {
    return await _dbService.fetchAllTasks();
  }

  Future<List<Request>> fetchVolunteerRequests(String email) async {
    return await _dbService.fetchRequestsByVolunteer(email);
  }

  Future<void> submitRequest(Request request) async {
    await _dbService.saveRequest(request, request.eventId);
  }

  Future<void> updateRequestDetails(Request request) async {
    await _dbService.updateRequestDetails(request);
  }
}
