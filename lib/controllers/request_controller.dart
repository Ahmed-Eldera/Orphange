import 'package:hope_home/models/Event/request.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';

import '../models/auth/FireAuth.dart';
import '../models/state/state_types.dart';

class RequestController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  Future<List<Request>> fetchAllRequests() async {
    try {
      return await _dbService.fetchAllRequests();
    } catch (e) {
      throw Exception('Failed to fetch requests: $e');
    }
  }

  Future<void> updateRequestState(Request request) async {
    try {
      await request.updateRequestState();
    } catch (e) {
      throw Exception("Failed to update request state in database: $e");
    }
  }
  Future<String?> getLoggedInUserEmail() async {
    return await _authService.getLoggedInUserEmail();
  }
  Future<void> updateRequestDetails(Request request) async {
    await request.updateRequestDetails();
  }
  Future<void> submitRequest(String taskId, String eventId, String details) async {
    final email = await getLoggedInUserEmail();
    if (email == null) {
      throw Exception("User not logged in");
    }

    final request = Request(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: taskId,
      eventId: eventId,
      volunteerId: email,
      details: details,
    );

    await request.saveRequest(eventId);
  }
}