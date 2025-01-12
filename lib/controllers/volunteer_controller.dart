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
  Future<List<Task>> fetchTasksParticipated(String email) async {
    final requests = await _dbService.fetchRequestsByVolunteer(email);
    List<Task> tasks = [];
    for (var request in requests) {
      final task = await _dbService.fetchTaskById(request.taskId, request.eventId);
      if (task != null) {
        tasks.add(task);
      }
    }
    return tasks;
  }


  Future<List<Request>> fetchApprovedRequests(String email) async {
    final requests = await _dbService.fetchRequestsByVolunteer(email);
    return requests.where((r) => r.getStateName() == 'Approved').toList();
  }

  Future<int> calculateVolunteerHours(String email) async {
    final approvedRequests = await fetchApprovedRequests(email);
    return approvedRequests.length * 2; // 2 hours per approved request
  }
  Future<String?> fetchVolunteerName(String email) async {
    final userData = await _dbService.getUserByEmail(email);
    return userData?['name'];
  }


}
