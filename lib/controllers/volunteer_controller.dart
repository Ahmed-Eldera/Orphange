import 'package:hope_home/controllers/communication_context.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';
import '../models/Event/request.dart';
import '../models/Event/task.dart';
import '../models/auth/FireAuth.dart';
import '../models/users/volunteer.dart';

class VolunteerController {
  // CommunicationContext _context = CommunicationContext();
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  // Future<void>? notifyUsers(){print("");}
  Future<List<Volunteer>> getAllVolunteers() async {
    return await _dbService.fetchAllVolunteers();
  }

  Future<List<Request>> fetchVolunteerRequests(String email) async {
    return await _dbService.fetchRequestsByVolunteer(email);
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
  Future<List<Task>> fetchTasksForVolunteer() async {
    final email = await getLoggedInUserEmail();
    if (email == null) {
      throw Exception('Unable to fetch logged-in user email');
    }
    return await _dbService.fetchTasksByVolunteerEmail(email);
  }
  Future<String?> getLoggedInUserEmail() async {
    return await _authService.getLoggedInUserEmail();
  }
  Future<List<Request>> fetchRequestsForLoggedInVolunteer() async {
    final email = await _authService.getLoggedInUserEmail();
    if (email == null) {
      throw Exception("No logged-in user found");
    }
    return await _dbService.fetchRequestsByVolunteer(email);
  }


  Future<Map<String, dynamic>> fetchCertificateData() async {
    final email = await getLoggedInUserEmail();
    if (email == null) {
      throw Exception('User not logged in');
    }

    final name = await fetchVolunteerName(email);
    final tasks = await fetchTasksParticipated(email);
    final approvedRequests = await fetchApprovedRequests(email);
    final hours = await calculateVolunteerHours(email);

    return {
      'email': email,
      'name': name,
      'tasks': tasks
          .map((task) => {'name': task.name, 'description': task.description})
          .toList(),
      'approvedRequests': approvedRequests
          .map((request) => {
        'taskId': request.taskId,
        'details': request.details,
      })
          .toList(),
      'hours': hours,
    };
  }
}
